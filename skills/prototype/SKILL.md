---
name: prototype
description: Build a throwaway prototype that answers a specific question — either "does this logic feel right?" or "what should this look like?". Captures the answer in docs/rfc/ or the matching tasks/ file before deletion. Use when user wants to spike, prototype, sketch, or validate a design before committing to a real implementation.
---

# Prototype

A prototype is **throwaway code that answers a question**. The question decides the shape.

## Pick a branch

Identify which question is being answered — from the user's prompt, the surrounding code, or by asking if the user is around:

- **"Does this logic / state model feel right?"** → build a tiny interactive terminal app (or unit-test harness) that pushes the state machine through cases that are hard to reason about on paper.
- **"What should this look like?"** → generate several radically different UI variations on a single route, switchable via a URL search param and a floating bottom bar.

The two branches produce very different artifacts — getting this wrong wastes the whole prototype. If the question is genuinely ambiguous and the user isn't reachable, default to whichever branch better matches the surrounding code (a backend module → logic; a page or component → UI) and state the assumption at the top of the prototype.

## Rules that apply to both

1. **Throwaway from day one, and clearly marked as such.** Locate the prototype code close to where it will actually be used so context is obvious — but name it (e.g. `__prototype__/`, `*.proto.ts`, `playground/`) so a casual reader can see it's a prototype, not production. Obey whatever routing/folder convention the project already uses; don't invent new top-level structure.
2. **One command to run.** Whatever the project's existing task runner supports — `<run-server-command>` from `CLAUDE.md`, or a single `npm run …` / `python …` / `bun …` invocation. The user must be able to start it without thinking.
3. **No persistence by default.** State lives in memory. Persistence is the thing the prototype is *checking*, not something it should depend on. If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE — wipe me" name.
4. **Skip the polish.** No tests, no error handling beyond what makes the prototype *runnable*, no abstractions. The point is to learn something fast and then delete it.
5. **Surface the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user can see what changed.
6. **Delete or absorb when done.** When the prototype has answered its question, either delete it or fold the validated decision into the real code — don't leave it rotting in the repo.

## When done — capture the answer, then delete

The *answer* is the only thing worth keeping from a prototype. Capture it in the most durable place that already exists in this kit:

- If the prototype was validating an architectural choice → write or update `docs/rfc/<slug>.md` with the verdict.
- If the prototype was validating an in-flight task → append a "Prototype findings" section to the matching `tasks/<id>-<slug>.md`.
- Otherwise → drop a short ADR in `docs/adr/<NNNN>-<slug>.md` only if the decision is hard-to-reverse and surprising-without-context.

If the user is around, that capture is a quick conversation; if not, leave a `TODO(prototype-findings)` placeholder so they (or you, on the next pass) can fill in the verdict before deleting the prototype.
