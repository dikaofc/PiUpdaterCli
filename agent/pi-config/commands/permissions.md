---
description: Show the effective permission matrix and current approval mode
---

Rep
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ort the effective permission model. Facts come from `cap`, not from guessing.

1. `cap permissions` — effective permission matrix (read, write, execute, network, database-read, database-write, git-write, system), including per-plugin grants.
2. Read `.claude/settings.json` for `cap.approvalMode` (`manual | smart | autonomous | review-only`, default `smart`).
3. If an argument names a permission or plugin (e.g. `write` or a plugin name), show just that row and its source.

Interpret the approval mode for the user:
- `smart`: write/risky operations require approval; read/test/lint run automatically.
- `manual`: every write/risky operation prompts.
- `autonomous`: operations proceed without prompting.
- `review-only`: all operations are proposed for review rather than executed.

Output: a permission matrix table + the active approval mode + a one-line meaning of that mode.