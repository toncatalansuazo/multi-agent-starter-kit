#!/usr/bin/env bash
#
# link-skills.sh — install this kit's skills into a Claude skills directory
# by creating a symlink per SKILL.md.
#
# Usage:
#   scripts/link-skills.sh                # default: --global
#   scripts/link-skills.sh --global       # symlink into ~/.claude/skills
#   scripts/link-skills.sh --project      # symlink into ./.claude/skills
#   scripts/link-skills.sh --target PATH  # symlink into a custom directory
#   scripts/link-skills.sh --dry-run      # print what would happen, do nothing
#
# The script is idempotent: re-running it overwrites existing symlinks but
# refuses to clobber non-symlink directories that already exist at the target.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="${REPO}/skills"

MODE="global"
TARGET="${HOME}/.claude/skills"
DRY_RUN=0

usage() {
  sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      MODE="global"
      TARGET="${HOME}/.claude/skills"
      shift
      ;;
    --project)
      MODE="project"
      TARGET="$(pwd)/.claude/skills"
      shift
      ;;
    --target)
      if [[ $# -lt 2 ]]; then
        echo "error: --target requires a path argument" >&2
        exit 2
      fi
      MODE="custom"
      TARGET="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument '$1'" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "error: no skills/ directory found at $SKILLS_DIR" >&2
  exit 1
fi

# Resolve TARGET to an absolute path (without requiring it to exist yet),
# then collapse "/./" segments and any trailing slash so the in-source guard
# below compares apples to apples.
case "$TARGET" in
  /*) ABS_TARGET="$TARGET" ;;
  *)  ABS_TARGET="$(pwd)/$TARGET" ;;
esac
ABS_TARGET="$(printf '%s' "$ABS_TARGET" | sed -e 's|/\./|/|g' -e 's|/\{2,\}|/|g' -e 's|/$||')"

# Refuse only when the target is the skills source dir (or under it) — that
# would create circular symlinks. Targets elsewhere inside the repo (e.g. a
# cloned kit's own .claude/skills) are fine and intentional for --project.
case "$ABS_TARGET" in
  "$SKILLS_DIR"|"$SKILLS_DIR"/*)
    echo "error: target $ABS_TARGET is inside skills/; refusing to symlink onto itself." >&2
    exit 1
    ;;
esac

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] would install to $ABS_TARGET ($MODE mode)"
else
  mkdir -p "$ABS_TARGET"
fi

count=0
skipped=0
while IFS= read -r -d '' skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  link_path="${ABS_TARGET}/${skill_name}"

  # If something exists at link_path that is not a symlink, refuse rather than
  # overwrite — the user may have hand-authored a skill there.
  if [[ -e "$link_path" && ! -L "$link_path" ]]; then
    echo "skip $skill_name -> $link_path (existing non-symlink)" >&2
    skipped=$((skipped + 1))
    continue
  fi

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[dry-run] link $skill_name -> $skill_dir"
  else
    ln -sfn "$skill_dir" "$link_path"
    echo "linked $skill_name -> $skill_dir"
  fi
  count=$((count + 1))
done < <(find "$SKILLS_DIR" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -print0)

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] $count skills would be installed, $skipped skipped."
else
  echo "Installed $count skills to $ABS_TARGET ($MODE mode); $skipped skipped."
fi
