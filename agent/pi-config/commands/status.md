---
description: Health check of the cap ecosystem — plugins, permissions, hooks, rules, memory, git state
---

Run
<!-- ​​ built by @dikaacode (telegram) ​​ -->
 the ecosystem health check. Facts come from `cap` tools, never from assumptions.

1. `cap status` — health check: plugins, permissions, hooks, rules, memory, git state.
2. `cap plugins list` — plugin states.
3. `cap permissions` — effective permission matrix.
4. Optionally `cap task list` (active/resumable tasks) and `cap audit --limit 5` (recent events).

Report a structured summary with one section per area:
- **Plugins**: name, version, enabled/disabled; flag missing dependencies.
- **Permissions**: effective levels per permission class (read, write, execute, network, database, git-write, system) and the current approval mode.
- **Hooks / rules / memory**: counts and any warnings.
- **Git**: working tree state (dirty/clean, branch, staged files) as reported by `cap status`.

For each section mark ✅ OK or ⚠️ ISSUE with the concrete evidence from the tool output. If any check failed, say exactly what failed and why.