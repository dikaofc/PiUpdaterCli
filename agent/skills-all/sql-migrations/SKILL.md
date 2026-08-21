---
name: sql-migrations
description: Write safe database migrations — additive first, backfills, locking, rollback, zero-downtime changes.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQL Migrations

## Rules (SQL rules file also applies)
- **Additive > destructive**: new column/tables first; remove only after code no longer references.
- One migration = one intent, reversible pair (up/down); every change has a documented rollback (see `sql.md`).
- Wrap multi-statement in transaction (DDL transactional on PG — MySQL implicit commits!).

## Dangerous ops (zero-downtime aware)
- **Backfill**: don't UPDATE 50M rows in one tx (locks table for hours) — batch in chunks (e.g. `WHERE id BETWEEN ... AND ... LIMIT 5000`) via background job, or add column NULL → fill → set NOT NULL.
- **Add column with DEFAULT/NOT NULL**: PG 11+ fine (`ADD COLUMN ... DEFAULT x NOT NULL` no rewrite); MySQL may copy table — long table → `ALGORITHM=INPLACE, LOCK=NONE` check.
- **Drop column/index**: double-check read/write in code gone; MySQL drop column = full table rebuild — schedule.
- **Index on hot table**: `CREATE INDEX CONCURRENTLY` (PG) — never blocking; verify no duplicates first.
- **Renames**: `RENAME COLUMN` breaks running code — sequence: add new → dual-write → backfill → swap reads → drop old.

## Process
- Migration files in order (timestamps); CI runs fresh DB from zero: `migrate up` + `down` round-trip test.
- 4-eyes review before merge (see `sql.md` review triggers); confirm row counts/approximate durations against prod stats.
- Preprod: run against a copy of prod data; capture timing + locks held (pg_locks/innodb status) during rehearsal.
- Never auto-run destructive migration in deploy pipeline — gate with explicit confirmation.

## Checklist
- [ ] Additive ordering; rollback written
- [ ] Backfills chunked, NOT NULL after fill
- [ ] Indexes concurrent-safe
- [ ] Renames dual-versioned
- [ ] Rehearsed on prod-like data
- [ ] Docs: data-loss plan if any DROP/TRUNCATE