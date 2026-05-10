---
name: zoom-out
description: Tell the agent to zoom out and give broader context or a higher-level perspective using the kit's docs/context.md vocabulary and docs/rfc/ architecture. Use when you're unfamiliar with a section of code or need to understand how it fits into the bigger picture.
disable-model-invocation: true
---

I don't know this area of code well. Go up a layer of abstraction. Give me a map of the relevant modules and callers using the vocabulary in `docs/context.md`. Cross-reference any matching `docs/rfc/<slug>.md` and `docs/adr/` so I see the *intended* architecture next to the actual one — and call out where they disagree.
