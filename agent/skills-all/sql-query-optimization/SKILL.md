---
name: sql-query-optimization
description: Optimize SQL queries — EXPLAIN plans, indexes, N+1, pagination, slow patterns, schema hints.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQL Query Optimization

## Method (measure first)
1. Capture the slow query (slowlog, `pg_stat_statements` / `performance_schema`).
2. `EXPLAIN ANALYZE` the exact query — read plan top-down: seq scan? rows estimate vs actual? sort? join order?
3. Fix by index or rewrite; re-run — confirm plan change + latency drop.

## Indexes
- Index what WHERE/JOIN/ORDER BY filters on, in that column order (`(tenant_id, created_at)` for tenant-scoped list).
- Covering: `(a, b) INCLUDE (c)` avoids heap lookup — wins for hot lists.
- Partial `WHERE status='active'` for sparse booleans; expression index `lower(email)`.
- Don't index low-cardinality alone (`status`) without leading column. Watch write amplification: each index slows inserts; drop unused (pg_stat_user_indexes usage).
- LIKE '%x' unindexable (pg_trgm/full-text instead); `!=`/`OR` weaken; functions on columns kill index — rewrite `WHERE created_at::date = ...` to range.

## Patterns that kill
- **N+1**: per-row queries in loops — batch with `IN`/join (app side too).
- `SELECT *` over wide rows into app; fetch only needed columns.
- Deep `OFFSET` (skip 100k) → keyset pagination (`WHERE id > last ORDER BY id LIMIT 50`).
- Correlated subqueries when a join+group does it; `COUNT(*)` over huge tables (maintain counter or approximate).
- `NOT IN (subquery)` NULL trap → `NOT EXISTS`.
- Unnecessary DISTINCT/GROUP BY (often a join-shape smell).
- ORMs: check generated SQL; map n-plus pattern to includes/joins; watch eager-loading everything.

## Verification
- EXPLAIN ANALYZE shows: seq scan vs index scan on hot tables; rows estimate within 10×; join not temp-file-hashing millions.
- Set: `track_io_timing` on; measure before/after p95.

## Checklist
- [ ] EXPLAIN ANALYZE reviewed for target query
- [ ] Indexes match filter order, covering where hot
- [ ] No N+1, no OFFSET pagination
- [ ] No function-wrapped indexed columns
- [ ] Unused indexes dropped