---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Lighter-weight cousin of grill-with-docs — does not require docs/context.md or docs/adr/. Use when user wants to stress-test a plan, get grilled on their design, or says "grill me".
---

# Grill Me

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead of asking.

## Heuristics

- **One question per turn.** Never stack three questions hoping the user picks the easiest. They will, and the others rot.
- **Always recommend.** Each question must come with your best guess and the reason. The user's job is to override, not to author.
- **Resolve before opening.** If question B depends on the answer to A, ask A first. Don't open three threads in parallel.
- **Stop fishing.** When you've reached "I have no remaining questions that would change the plan", say so and stop. Don't manufacture questions for symmetry.

## When to escalate to grill-with-docs

If you find yourself constantly checking against the project's existing decisions — vocabulary in `docs/context.md`, architecture in `docs/rfc/`, or accepted ADRs in `docs/adr/` — switch to `/grill-with-docs`. That skill is the same interview pattern, but explicitly anchored to the kit's documentation.
