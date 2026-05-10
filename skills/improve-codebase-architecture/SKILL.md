---
name: improve-codebase-architecture
description: Surface shallow modules and propose deepening refactors using domain vocabulary from docs/context.md, current architecture from docs/rfc/, and accepted decisions in docs/adr/. Emits accepted refactors as new task files in tasks/ and roadmap.json entries. Use when the user asks to improve architecture, reduce coupling, deepen modules, or audit module boundaries.
---

# Improve Codebase Architecture

A skill for finding leverage in the existing codebase and turning architectural pain into concrete, executable tasks. Three phases: explore, present, grill.

## Vocabulary

- **Module** — a unit of code with an interface and a hidden body. Avoid generic words like "service", "component", "manager" unless `docs/context.md` already defines them.
- **Depth** — interface narrowness × implementation richness. A deep module hides a lot behind a small interface.
- **Seam** — a place where behaviour can change without editing call sites in place.
- **Deletion test** — would removing this module change behaviour, or is it a pass-through?

## Phase 1 — Explore

Start by reading:

- `docs/context.md` — domain vocabulary
- `docs/rfc/` — current architecture intent
- `docs/adr/` — accepted decisions you must respect or formally reopen
- `roadmap.json` and `tasks/` — what is in flight (don't propose refactors that collide with active work)

Then walk the codebase organically. Note friction points where:

- understanding one module requires bouncing between three others;
- the interface description is as long as the implementation;
- multiple callers each duplicate the same setup before invoking a module;
- a "manager"/"service" passes nearly every call straight through to something else (deletion-test candidate);
- tests of one module mostly mock another module — the seam is in the wrong place.

Do not propose interfaces in this phase. Just collect candidates.

## Phase 2 — Present candidates

Output a short list of **deepening opportunities**, each phrased as:

> **<module name>** — currently <shallow shape>. Could deepen by <hidden complexity to absorb>. Leverage: <what this lets future work skip>.

Use vocabulary already in `docs/context.md`. If you need a new term to describe a candidate, flag it as "naming TBD".

If a candidate conflicts with an existing ADR, do **not** silently override — surface it: "ADR-0007 chose Y, but the friction here suggests reopening it. Reopen?"

Stop and let the user pick. Do not start grilling all candidates at once.

## Phase 3 — Grill the chosen candidate

Once the user picks one, walk the design tree the way `/grill-with-docs` does:

- One question at a time, with a recommended answer.
- Resolve dependencies between sub-decisions before opening new ones.
- Update `docs/context.md` inline when a new concept is named.
- Offer an ADR in `docs/adr/<NNNN>-<slug>.md` only when (hard-to-reverse) ∧ (surprising-without-context) ∧ (real-trade-off).

## When done — emit work, don't just talk

Once the refactor is agreed, the conversation must produce **executable artifacts**, not a memo:

1. Write or update the relevant `docs/rfc/<slug>.md` so the new shape is the documented architecture.
2. Create `tasks/<NN>-<slug>.md` files for each independently-shippable step (one task = one PR's worth of work).
3. Append matching entries to `roadmap.json` with `"status": "pending"` and the correct `"file_path"`.
4. Hand off to the `architect` agent (per `CLAUDE.md`) so the task file gets fleshed out before `backend` / `frontend` agents touch code.

If the refactor is too big to land safely, say so explicitly and split until each step is independently shippable.
