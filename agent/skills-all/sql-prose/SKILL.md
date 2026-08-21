---
name: sql-prose
description: Write clean, safe SQL — parameterization, transactions, isolation levels, CTEs, window functions. Use for any query or schema work.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQL (core)

## Safety (rules from sql.md)
- **Parameterize always** — never string-concatenate user input; no variable interpolation in SQL strings.
- `LIMIT` on unbounded selects (admin reports cap 10k; UI paginated).
- No `DROP`/`TRUNCATE` without data-loss plan + rollback doc.
- Multi-statement changes in transaction.

## Structure
- Readable: UPPERCASE keywords, one clause per line; alias eagerly (`FROM users u`); qualify columns (`u.id`).
- CTEs over nested subqueries for stepwise logic; window functions `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` for dedupe/top-N (≠ GROUP BY semantics).
- `WITH` CTE: materialized in PG when referenced once — don't reuse heavily in one query (copy risk).
- `INSERT ... ON CONFLICT (key) DO UPDATE` (PG) / `INSERT IGNORE` (MySQL) for upserts — decide conflict target explicitly.

## Transactions & isolation
- Default READ COMMITTED fine for most; REPEATABLE READ protects read-consistent batches (PG); SERIALIZABLE only with retry-on-serialization-failure.
- Keep txn short (no app I/O inside); choose lock order consistently (deadlock prevention); `SELECT ... FOR UPDATE` only on the rows you truly serialize.
- Concurrency: `SELECT ... FOR UPDATE SKIP LOCKED` for queue-style claims; advisory locks for cross-txn gates.

## Verification
- `EXPLAIN` on new joins in CI; parameterize all dynamic filters; typed casts (`::int`, `DATE '2026-08-20'`) over implicit.

## Checklist
- [ ] Parameterized, no interpolation
- [ ] LIMIT on scans; caps on reports
- [ ] Transaction wraps related writes
- [ ] Isolation chosen deliberately
- [ ] Readable CTE over nested subqueries