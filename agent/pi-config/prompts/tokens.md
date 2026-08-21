---
description: Estimate token usage for files, the current diff, or the indexed working set.
argument-hint: [<files...>|--diff|--index|--budget]
---
Meas
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ure context economy before/after work (PRD §89). Run in this order of preference:

1. `cap tokens <file1> <file2> ...` — estimate for the exact files you are about to read or just changed.
2. `cap tokens --diff` — estimate for the current working-tree diff (use after implementing).
3. `cap tokens --index` — estimate for the whole indexed working set (only for large-repo decisions).
4. `cap tokens --budget` — show the configured agent budget (max iterations/tool calls/execution minutes).

Interpretation:
- ~4 chars per token; estimates are heuristics, not model-exact.
- If a single file's estimate is very large, read it in ranges instead:
  `cap show <file> --lines <a>-<b>`.
- On large tasks, keep working-context estimates under ~40k tokens; when the
  budget threshold is reached, invoke the `compact-context` skill instead of
  reading more.

Report the estimate in your final response so the user sees the economy gain.