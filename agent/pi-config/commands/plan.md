---
description: Build an implementation plan (goal, files, steps, tests, risk, rollback) and get approval before any edit
argument-hint: <task description>
---

Pla
<!-- ​​ built by @dikaacode (telegram) ​​ -->
n first, edit only after explicit approval. This is a planning command — do not modify files in it.

1. Require a task description. If missing, ask for it.
2. `cap plan "<task>" --json` — get the structured plan: goal, affected files, steps, tests, risk, rollback.
3. Validate the plan against reality:
   - `cap status` — working tree state.
   - `cap diff` — existing uncommitted changes that could conflict.
   - `cap explore "<task keywords>"` / `cap search "<task keywords>"` — confirm the affected files/symbols exist as named.
4. Present the plan with sections: **Goal**, **Affected files** (file:line), **Steps**, **Tests** (targeted + related + full), **Risk**, **Rollback** (`cap rollback --task <id>` or `--file <path>`).
5. Ask for explicit approval before any edit. If approval is refused or the plan is stale, revise the plan, do not proceed.

Output: the structured plan plus a clear question asking whether to proceed.