---
name: code-reading-navigation
description: Navigate and read unfamiliar codebases efficiently — entry points, call graphs, data flow, grep strategies.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Code Reading & Navigation

## Orient (5 min, top-down)
1. README + `package.json`/pyproject/go.mod — dependencies, scripts, test command.
2. Directory shape → architecture guess (layers? feature dirs?).
3. Entry point (main/index/app) → trace one request end-to-end: route → middleware → handler → service → repo → DB → back.
4. Note config files: envs, CI steps (deploy, test) — they reveal operational reality.

## Read one flow, not the whole tree
- Question-first: "where does X get set / who calls Y" — `rg -n 'symbol' src` + `rg -n 'callsite' ` to build call graph.
- Follow data: type/class → constructor sites → mutation sites (grep for assignment/`setX`).
- Trace with breakpoints/logs when static reading fails (dynamic beats guessing).

## Grep playbook (the meta-skill)
- `rg 'Symbol' src/` exact; `rg -w` word-boundary; `rg -i` case-insensitive for sql/camel variations.
- `rg 'from "x"' -l` who imports module; `rg '\.method\(' -t ts` usage sites.
- History: `git log -S'Symbol' -- file` (when added/removed — `git-workflows`).
- Cross-language: schemas ↔ migrations ↔ types mapping (find the source of truth, don't patch drift).

## Understanding techniques
- **Read the tests** — they're executable docs (expected behavior + edge cases).
- Commit history for "why" (git blame on the confusing line → commit message).
- Rename mentally: unclear code → note your hypothesis, verify by running.
- Draw the map (in notes): entities, flows, ownership; update as you learn.

## When stuck
- Check docs/examples before source-diving; the simplest implementation is often the canonical one (don't over-analyze three historical alternatives).

## Checklist
- [ ] README + deps + entry point read
- [ ] One full request flow traced
- [ ] Grep used for call graph, not guessing
- [ ] Tests read for behavior truth
- [ ] Map noted; verified by running