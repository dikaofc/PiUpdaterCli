---
name: sql-tuning
description: Diagnose and fix slow queries using plans, indexes, and query rewrites.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: performance
  tags: [sql, performance, database]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQL Tuning

## Objective
Turn a slow query into a fast one with an explainable plan and minimal added indexes.

## Preconditions
- `cap repo` run; query and DB dialect known.
- Access to EXPLAIN/query logs via `cap search` for the slow query.

## Workflow
1. Locate the query (`cap search <table|query>`) and `cap show` its definition and call sites.
2. Run EXPLAIN (ANALYZE where possible) on the query; identify scans, sorts, and join blowups.
3. Add the smallest covering index that serves the predicate and sort; verify it is used.
4. Rewrite N+1 loops, correlated subqueries, and `SELECT *` into set-based or joined queries.
5. Re-run EXPLAIN and the app test path; confirm latency dropped without regressing writes.
6. Record the before/after plan and index rationale with `cap memory add`.

## Verification
- [ ] EXPLAIN shows index seek, not full scan.
- [ ] Query latency improved and measured.
- [ ] No new redundant index.
- [ ] Write path still passes existing tests.

## Failure Handling
- If the planner ignores the index, check stats/casts/collation mismatch.
- If query is inherent to data volume, move work to precompute/materialize.

## Output Format
Report: slow query, plan before/after, index added, rewrite applied, measured latency delta.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
