---
name: grill-with-docs
description: Grilling session that challenges your plan against the kit's existing PRDs, RFCs, domain glossary, and ADRs, and updates docs/context.md and docs/adr/ inline as decisions crystallise. Use when user wants to stress-test a plan against this project's language and documented decisions before the architect agent flesh-out.
---

# Grill With Docs

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase or reading existing docs, do that instead of asking.

</what-to-do>

<supporting-info>

## Documents to read before grilling

This kit keeps written context in fixed locations. Before the first question, sweep:

- `docs/context.md` — project-wide domain glossary. Source of truth for shared vocabulary.
- `docs/prd/` — product requirements documents. Establishes the *what* and *why*.
- `docs/rfc/` — technical RFCs. Establishes the *how* at the architecture level.
- `docs/adr/` — accepted architecture decision records (lazy-created; may not exist yet).
- `roadmap.json` and `tasks/` — current execution state.

If any directory is missing, that itself is information — note it and create lazily as decisions land.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `docs/context.md`, call it out immediately. "The glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code and existing docs

When the user states how something works, check whether the code, current PRDs, and RFCs agree. If you find a contradiction, surface it: "The PRD says partial cancellation is in scope, but you just said the system only cancels whole orders — which is right?"

### Update docs/context.md inline

When a term is resolved, update `docs/context.md` right there. Don't batch — capture as it happens. Keep entries short: term, plain-language definition, one example, one gotcha if any. Don't couple `docs/context.md` to implementation details — only include terms meaningful to domain experts.

### Offer ADRs sparingly

Only offer to create an ADR in `docs/adr/<NNNN>-<slug>.md` when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR.

## When done

Hand off to the `architect` agent (per `CLAUDE.md`) with a one-paragraph summary of the resolved decisions and any open questions that still need flesh-out at the technical level.

</supporting-info>
