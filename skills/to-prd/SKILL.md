---
name: to-prd
description: Synthesise the current conversation and codebase context into a Product Requirements Document at docs/prd/<slug>.md. Optionally seed tasks/ files and roadmap.json entries. Use when user says "turn this into a PRD", "write a PRD", or wants to capture a feature spec before the architect agent flesh-out.
---

# To PRD

Turn the current shared understanding into a written PRD. Do not interview — that is `/grill-me` and `/grill-with-docs`. This skill assumes alignment already exists and your job is to write it down well.

## Inputs to read first

- The current conversation (what was just discussed and decided).
- `docs/context.md` so vocabulary is consistent with the rest of the project.
- `docs/prd/` so the slug, structure, and tone match existing PRDs.
- `docs/rfc/` so you don't smuggle architecture decisions into the PRD body — link to the RFC instead.

## Module sketch

Before writing, sketch the major modules the feature implies. You are not designing them in detail — that is the `architect` agent's job — but the PRD should make obvious **where** the feature lives. Prefer deep modules (significant behaviour behind a small interface).

If a module is genuinely new, name it tentatively and flag the name as "TBD — confirm with `architect`".

## Output location

Write to `docs/prd/<slug>.md`. Slug rules:

- Lowercase, hyphenated, ≤ 5 words.
- Match the verb–noun pattern of existing PRDs in the folder.
- If a PRD with the same slug exists, ask before overwriting.

## PRD template

```markdown
# <Feature title>

> Status: draft · Owner: <user> · Created: <YYYY-MM-DD>

## Problem

<Two to four sentences. What hurts today, for whom, and why now.>

## Solution

<One to three paragraphs of the *what*, not the *how*. External behaviour
only. Link to `docs/rfc/<slug>.md` for the technical shape.>

## User stories

- As a <role>, I can <capability>, so that <outcome>.
- ...

## Out of scope

- <Things a reader might assume are included but aren't.>

## Implementation decisions worth flagging

<Only the choices that constrain the architect — e.g. "must reuse the
existing identity module", "no new external dependencies". Not a design.>

## How we'll know it works

<Observable acceptance signals. Avoid implementation-level test specs.>

## Open questions

- <Question> — <who decides, by when>
```

## After writing

1. Add the PRD path to the top of any matching `tasks/<id>-<slug>.md` files so downstream agents pick up the link.
2. If no tasks exist yet for this feature, propose a list of independently-shippable task slices to the user, then create them once approved (one `tasks/<NN>-<slug>.md` per slice + matching `roadmap.json` entry with `"status": "pending"`).
3. Hand off to the `architect` agent (per `CLAUDE.md`) for the technical flesh-out pass.

Do not mark anything `done` in `roadmap.json` yourself — that is the orchestrator's responsibility.
