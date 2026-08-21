---
name: sql-query-optimize
description: Optimize SQL queries with EXPLAIN-driven indexing and query tuning.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and read access to the project's database for `EXPLAIN`; honors the project's parameterized-query and LIMIT rules.
metadata:
  category: review
  tags: [sql, database, indexing, query, explain]
---
<!-- ​​built by @dikaacode (telegram)​​ -->

# SQL Query Optimize

## Objective
Improve slow SQL in a codebase by measuring first: capture `EXPLAIN`/`EXPLAIN ANALYZE` plans for the target queries, identify the dominant cost (seq scans, missing indexes, row estimation drift, N+1-shaped loops), apply the smallest fix — a covering index, a filter reorder, a join rewrite, or a LIMIT-worthy pagination — and re-measure to prove the win. Parameterized queries and a `LIMIT` on unbounded selects are non-negotiable throughout.

## Preconditions
- The slow queries are identified (from `cap review` findings, logs, or explicit bug reports) and reachable in the schema.
- Read-only access exists to run `EXPLAIN ANALYZE` against a representative dataset — never against the prod write path.
- A baseline timing/plan capture exists for each target query.

## Workflow
1. Run `cap status` and `cap repo` to locate the schema, migrations, and the query definitions; read them with `cap show`.
2. Isolate the query text with `cap search "<table>\s*JOIN|WHERE|ORDER BY"` targeted to the suspicious modules, then find its data-layer handler via `cap explore <symbol>`.
3. Capture the baseline plan for each query (with `EXPLAIN ANALYZE` where read-only allows) and record it with `cap memory add`: scan type, estimated vs. actual rows, and cost lines.
4. Diagnose by cost: a `Seq Scan` on a hot filter column → candidate index; a large `rows` estimation gap → stale statistics (`ANALYZE`) or a missing composite index; correlated subquery per row → rewrite as a join or window.
5. Write the smallest fix: add the index as a new migration (never editing a released migration), reorder predicates to match index order, or rewrite the query to a parameterized join. Verify the change against `cap rules check <file>` for the SQL rule set.
6. Re-run `EXPLAIN ANALYZE` on the same dataset and confirm the plan changed in the diagnosed direction; record before/after rows-scanned and duration.
7. Change SQL in application code via parameterized statements only; run `cap search` to confirm no string-concatenated user input remains in the touched queries.
8. Run `cap test` (the query-path tests), `cap lint`, and `cap verify`; then `cap diff` to confirm the fix surface.
9. Record the durable facts (`cap memory add`): the perf delta, the index name, and the query pattern to re-check in future reviews.

## Verification
- [ ] Baseline and post-fix `EXPLAIN ANALYZE` captured for the same dataset; the plan changed in the diagnosed direction.
- [ ] No unbounded `SELECT` in touched queries — every unbounded case now carries `LIMIT` or an explicit, documented reason.
- [ ] All touched queries are parameterized (`cap search` shows zero concatenation at those sites).
- [ ] New indexes are additive migrations with a rollback step; no released migration edited (`cap rules check` and `cap diff` confirm).
- [ ] `cap test`/`cap lint`/`cap verify` green.

## Failure Handling
- The fix does not change the plan: revert with `cap rollback --task <id>`, re-read the query text and the actual statistics, and re-diagnose — never ship an index that does not get used.
- Verifying against prod is not permitted: use a restored staging snapshot or an anonymized copy; if none exists, report the blocker and the exact re-measure command.
- An index improves one query but regresses writes: run the write-path tests (`cap test` on insert/update paths) and weigh the trade-off; document the decision — do not silently keep a hot-path index without the write regression check.
- The "slow" query is actually N+1 from the ORM: fix the ORM batching/join at the data layer instead of adding a database index; note the corrected root cause in the report.

## Output Format
Final report:
- Per query: baseline plan → post-fix plan (scan type, rows-scanned, duration) before/after.
- Changes applied: index/migration, predicate reorder, join rewrite, LIMIT additions, or ORM fix.
- Verification: `cap rules check`, parameterization proof via `cap search`, `cap test`/`cap verify` results.
- Final `cap diff` summary and any deferred trade-offs with reasons.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap explore`, `cap rules check`, `cap test`, `cap lint`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.
- SQL rules (project `.claude/rules/sql.md`): parameterize, LIMIT, transactional migrations, review triggers.