---
name: write-a-skill
description: Scaffold a new skill in this kit at skills/<name>/SKILL.md following the project's conventions, then remind the user to run scripts/link-skills.sh to install it. Use when user says "write a skill", "create a skill", "scaffold a skill", or "turn this workflow into a skill".
---

# Write A Skill

A skill is a small markdown file (`SKILL.md`) that an agent can load on demand. The directory name is the skill's slug.

## Process

1. **Gather requirements.** Ask the user, in this order:
   - What trigger phrases should make agents reach for this skill?
   - What is the *one* outcome the skill produces?
   - Which of this kit's anchors does it touch — `docs/prd/`, `docs/rfc/`, `docs/adr/`, `docs/context.md`, `tasks/`, `roadmap.json`, the `.claude/AGENTS/` pipeline?

2. **Pick a slug.** Lowercase, hyphenated, verb-led where possible (`diagnose`, `to-prd`, `improve-codebase-architecture`). Check `skills/` to avoid collisions.

3. **Draft `SKILL.md`** at `skills/<slug>/SKILL.md` using the structure below.

4. **Review with the user.** Read the description aloud — that line is the *only* thing other agents see when deciding whether to load you. If it doesn't make the trigger obvious, rewrite it.

5. **Install.** Tell the user to run one of:
   - `scripts/link-skills.sh --global` — symlink into `~/.claude/skills/` (available in every project)
   - `scripts/link-skills.sh --project` — symlink into `./.claude/skills/` (this repo only)

## SKILL.md structure

```markdown
---
name: <slug>
description: <one paragraph, < 1024 chars. Lead with what the skill does. End with explicit "Use when ..." trigger phrases.>
---

# <Title Case>

<One-paragraph statement of intent. Why this skill exists.>

## <Phase or section>

<Concrete instructions. Imperative voice. No back-story.>

## When done

<What artifact the skill leaves behind, and which agent in CLAUDE.md picks up next.>
```

## Conventions for this kit

- **Anchor to existing files.** Reference `docs/prd/`, `docs/rfc/`, `docs/adr/`, `docs/context.md`, `tasks/`, and `roadmap.json` by exact path. Do not invent new top-level folders.
- **Hand off, don't claim done.** Skills should end by handing to the right agent in `.claude/AGENTS/` (architect, backend, frontend, ui-designer, qa-ux). Only the orchestrator flips `roadmap.json` status.
- **Split when long.** If `SKILL.md` exceeds ~120 lines, factor out reference sections into sibling files (`REFERENCE.md`, `EXAMPLES.md`) and link to them.
- **No time-sensitive content.** No "as of 2025"; skills outlive the conversations that spawned them.

## Review checklist before declaring done

- [ ] `description` ends with a clear "Use when ..." sentence
- [ ] Skill names exactly one outcome
- [ ] Every external reference points to a real path in this kit
- [ ] Hand-off agent is named explicitly
- [ ] Slug matches the folder name and the `name:` field
