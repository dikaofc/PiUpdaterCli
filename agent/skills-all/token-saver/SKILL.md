---
name: token-saver
description: Work with minimal token burn — metadata first, targeted search, bounded reads, budget tracking. Use for any large-repo or long-session work.
---

# Token Saver
<!-- ​​ built by @dikaacode (telegram) ​​ -->

Optimize context usage without losing correctness (PRD 89-90).

## Workflow

1. **Metadata first** — `cap repo` (one line), `cap headers <file>` (hash/lines/size), never `cap show` whole files first.
2. **Targeted search** — `cap explore <symbol>` and `cap search <query>` to locate the exact file:line before reading.
3. **Bounded reads** — `cap show <file> --lines a-b` for the region you need; read whole files only when small (< 300 lines) and load-bearing.
4. **Index before scanning** — `cap index --refresh` once; searches then hit the index instead of a full grep.
5. **Compact handoffs** — when delegating to an agent, hand over `file:line` references + one-line purpose, never raw file dumps.
6. **Budget track** — if the task is long, checkpoint: what is done, what remains, what was verified, in ≤ 5 lines.

## Rules

- Do not read a file you have already summarized this session.
- Do not include unchanged context in handoffs.
- When in doubt about a claim, verify with `cap search` (tools over hallucination, PRD 102).
- Verification stays mandatory: saving tokens never means skipping tests/lint (PRD 39).