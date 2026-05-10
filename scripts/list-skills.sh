#!/usr/bin/env bash
#
# list-skills.sh — print every SKILL.md in this repo, sorted, repo-relative.
#
# Useful for sanity-checking what link-skills.sh would install.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO"
find skills -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' \
  | sort
