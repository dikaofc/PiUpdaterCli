---
description: Check context and budget state; run compaction when the context window is nearly full.
---
Cont
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ext economy checkpoint (PRD §30, §51, §92):

1. Run `cap tokens --budget` to see the configured limits
   (max iterations, max tool calls, max execution minutes, max parallel agents).
2. Run `cap task list` and `cap task status <id>` for the active task —
   completed steps, pending steps, files changed, tests status.
3. Estimate current working context with `cap tokens --diff` (or explicit files).
4. Decide:
   - Under 80% of budget → continue normally, but prefer targeted reads
     (`cap search`, `cap show --lines`) over full-file reads.
   - At/over the warning threshold → do NOT keep reading. Invoke the
     `compact-context` skill: write `.claude/state/context-summary.md`
     (requirements, constraints, changed files, test failures, decisions,
     open issues, next steps) and continue from the summary.
   - Task budget exhausted → pause, report progress, and request
     continuation before doing more work.

Output format: budget values, current task state, estimated tokens used,
and the action taken (continue / compacted / paused).