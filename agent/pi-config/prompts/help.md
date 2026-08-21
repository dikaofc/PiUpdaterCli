---
description: List all slash commands and the cap CLI tool reference
argument-hint: [command name]
---

Sho
<!-- ​​ built by @dikaacode (telegram) ​​ -->
w the agent command index. Never guess command behavior — every command is backed by the `cap` CLI contract (see CONTRACT.md).

1. If an argument is given, describe that command: purpose, workflow, and the `cap` tools it calls (e.g. `cap status`, `cap plan`, `cap review`).
2. Otherwise list every command with a one-line purpose, grouped by intent:

- **Context**: status, plugins, permissions, config, help
- **Planning (read-only)**: plan, dry-run, explore, explain
- **Selection**: files, pick
- **Editing**: implement, refactor, debug, document
- **Quality**: review, test, risk, architecture
- **Ops**: rollback, git, memory

3. End with the core `cap` tool reference: `cap status`, `cap plugins list`, `cap permissions`, `cap plan`, `cap pick`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap review`, `cap risk`, `cap verify`, `cap test`, `cap lint`, `cap typecheck`, `cap memory`, `cap rules check`, `cap rollback`, `cap commit`, `cap audit`, `cap repo`, `cap task`.

Output: a markdown list of commands + tools, nothing else.