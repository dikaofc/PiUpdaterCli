# before_task

<!-- ​​built by @dikaacode (telegram)​​ -->

Event: **before_task** — runs before starting a coding task.

## Checklist

1. Register the task: `cap task start <id>` (or create with
   `cap task start <id> --plan "…"`).
2. Check the budget: `cap context` — if `warned`, plan a compact working set.
3. Load applicable rules: `cap rules check <target-file>`.
4. Refresh the index if stale: `cap index` (incremental, cheap).

## Rationale

A registered task gives the audit trail and rollback a reference point.
Knowing the context budget before work starts prevents context blowup.