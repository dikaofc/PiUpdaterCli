---
name: sqlite-db
description: Use SQLite correctly — WAL mode, indexes, migrations, concurrency limits, when to graduate to a server DB.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQLite

## Correct configuration
- Open every writable DB with: `PRAGMA journal_mode=WAL` (readers don't block writer, fewer fsyncs), `PRAGMA foreign_keys=ON` **per connection** (off by default!), `PRAGMA busy_timeout=5000`, `synchronous=NORMAL` (safe with WAL).
- WAL: keep `-wal`/`-shm` files on same disk; checkpoint automatically at 1000 pages — fine; heavy writers: manual `wal_checkpoint(TRUNCATE)` schedule.
- `journal_mode=WAL` + single-writer: multiple process readers OK; multiple writers = lock contention (busy_timeout retries).

## Schema & query
- Type affinity: declare `INTEGER PRIMARY KEY` (rowid alias), `TEXT NOT NULL`, `CHECK` where cheap; `STRICT` tables (3.37+) enforce types.
- Indexes same rules as SQL; `EXPLAIN QUERY PLAN` to confirm (scan vs search).
- `UPSERT` (`ON CONFLICT DO UPDATE`), window functions, CTEs — all supported; use them over app-side loops.
- Integer timestamps or ISO; `DATETIME` functions understand both — pick one consistently.

## Concurrency reality
- WAL = 1 writer, many readers; concurrent writes error `SQLITE_BUSY` (retry with backoff in app) — a small mutex/queue (single writer process) is the pragmatic pattern.
- Long transactions block checkpoints → WAL file grows → handle by short txns.
- Network FS is a footgun for WAL (lock semantics) — local disk only.

## Migrations & backups
- Migrations: transactions run ALTER in order; each connection must run the same migration version (PRAGMA user_version or a `schema_migrations` table).
- Backup: `VACUUM INTO 'backup.db'` (online, consistent) or `sqlite3 .backup`; never copy the live file while opened — WAL not flushed.

## When to graduate
- Sustained write throughput > ~10-100k writes/s, multi-region, or hard multi-writer concurrency → PostgreSQL (`postgres-admin`). SQLite handles read-heavy gigabyte apps fine — don't over-move.

## Checklist
- [ ] WAL + foreign_keys + busy_timeout per connection
- [ ] Single-writer pattern where needed
- [ ] EXPLAIN QUERY PLAN on hot queries
- [ ] Backups via VACUUM INTO
- [ ] Migration versioning applied per connection