---
name: tdd
description: Test-driven development with vertical-slice red-green-refactor cycles, wired to this kit's tasks/ files and qa-ux handoff. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# Test-Driven Development

## Philosophy

**Core principle**: tests should verify behaviour through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification — "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behaviour hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behaviour.

## Anti-pattern: horizontal slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" — treating RED as "write all tests" and GREEN as "write all code".

This produces **bad tests**:

- Tests written in bulk test _imagined_ behaviour, not _actual_ behaviour.
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behaviour.
- Tests become insensitive to real changes — they pass when behaviour breaks, fail when behaviour is fine.
- You outrun your headlights, committing to test structure before understanding the implementation.

**Correct approach**: vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

## Workflow inside this kit

### 1. Planning

Before any code:

- [ ] Read the matching `tasks/<id>-<slug>.md` so you know the agreed scope.
- [ ] Read `docs/context.md` so test names and interface vocabulary match the project's language.
- [ ] Respect any `docs/adr/` decisions in the area you're touching.
- [ ] List the behaviours to test (not implementation steps).
- [ ] Confirm with the user which behaviours matter most. **You can't test everything.**

Ask: "What should the public interface look like? Which behaviours are most important to test?"

### 2. Tracer bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   write test for first behaviour → test fails
GREEN: write minimal code to pass → test passes
```

This is your tracer bullet — proves the path works end-to-end.

### 3. Incremental loop

For each remaining behaviour:

```
RED:   write next test → fails
GREEN: minimal code to pass → passes
```

Rules:

- One test at a time.
- Only enough code to pass the current test.
- Don't anticipate future tests.
- Keep tests focused on observable behaviour.

Run with `<test-command>` from `CLAUDE.md` after every cycle.

### 4. Refactor

After all tests pass:

- [ ] Extract duplication.
- [ ] Deepen modules (move complexity behind simple interfaces).
- [ ] Apply SOLID where natural — not as a target.
- [ ] Run tests after each refactor step.

**Never refactor while RED.** Get to GREEN first.

## Per-cycle checklist

```
[ ] Test describes behaviour, not implementation
[ ] Test uses public interface only
[ ] Test would survive an internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

## When done

Hand off to the `qa-ux` agent (per `CLAUDE.md`) for the audit pass before the orchestrator flips `roadmap.json` to `"done"`. If you noticed an architectural seam was missing or in the wrong place, surface it via `/improve-codebase-architecture` rather than fixing it in the same PR.
