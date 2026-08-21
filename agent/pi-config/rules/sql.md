---
scope: sql
glob: **/*.sql
---

# SQL rules

<!-- ​​built by @dikaacode (telegram)​​ -->

Rules for SQL files and inline queries.

## Safety

- Never build queries by string concatenation of user input — parameterize.
- Use `LIMIT` on unbounded selects.
- Do not `DROP` or `TRUNCATE` in a migration without a documented data-loss plan
  and a rollback step.
- Wrap multi-statement changes in a transaction.

## Review triggers

- A migration touching existing tables must be reviewed before merge
  (`cap review`).
- Changing an index on a hot path requires a plan for lock/write amplification.