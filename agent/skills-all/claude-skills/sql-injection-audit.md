---
name: sql-injection-audit
description: Audit all SQL query construction for string concatenation and raw query builders; fix by parameterization, LIMIT, and transactions.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, search, show, and verification steps; a DB driver or adapter must be present in the project.
metadata:
  category: security
  tags: [sqli, database, parameterization]
---

# SQL Injection A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Find every place where SQL is built by string concatenation or by interpolating
values into query builders, prove which of those values can be attacker-controlled,
classify each finding as confirmed / probable / possible / false-positive, and fix
with parameterized queries following the SQL rules — parameterize, add `LIMIT` on
unbounded selects, and wrap multi-statement changes in transactions.

## Preconditions
- Repository indexed (`cap index --refresh`); a SQL engine or ORM is used.
- Trust boundaries are known: request bodies, headers, query strings, queue messages
  that flow into persistence layers.

## Workflow
1. Run `cap status` and `cap index --refresh`; confirm the SQL engine with `cap repo` (driver, ORM, Prisma/Knex/TypeORM/raw pools).
2. `cap search` concat sinks: `\$\{`/`+` inside strings with SQL keywords (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `WHERE`), `query\(\s*`, `execute\(\s*`, `raw\(`, `createQueryBuilder`, `whereRaw`, `orderBy\(.*\$\{`, and `format\s*\(` templating. Use `--path` globs for `*.sql`, `*.ts`, `*.js`.
3. `cap search` for ORM-primitive misuse: `.where(.+['"]\s*\+\s*`, `.orderBy(.+`interpolated, and client-side predicate builders that accept raw fragments.
4. For each candidate, trace value origin with `cap show <file> [--lines a-b]`: does the value come from a trust boundary (user input, headers, external API)? Is it quoted, escaped, or typed before reaching the query? Identifiers (table/column names, `ORDER BY` columns) cannot be parameterized — they need an allow-list check.
5. Classify: **confirmed** — attacker-controlled value reaches SQL via concatenation with a traced path; **probable** — strong pattern, path not fully exercised; **possible** — sink present, source unclear; **false-positive** — value is a constant, validated to a whitelist, or parameterized already. Also apply `.sql.md` rules: unbounded selects without `LIMIT` are findings; multi-statement writes without transactions are findings.
6. Fix: replace concatenation with bound parameters (`?`, `$1`, or the ORM's parameter API) for values; use allow-list validation for identifiers; add `LIMIT` to unbounded selects; wrap multi-statement changes in a transaction with a rollback path.
7. Re-check each patched statement with `cap show`, then run `cap lint`, `cap typecheck`, and tests with `cap test`; finish with `cap verify` and confirm scope with `cap diff`.

## Verification
- [ ] All query-construction sites searched, including ORM raw paths and .sql files.
- [ ] Every finding classified; each confirmed one has a value-origin trace to a trust boundary.
- [ ] No string-concatenated user value remains in any query.
- [ ] Unbounded selects have `LIMIT`; multi-statement changes run in transactions.
- [ ] `cap lint`, `cap typecheck`, `cap test` pass; `cap verify` is green.
- [ ] `cap diff` shows only intended fixes.

## Failure Handling
- If an exploit path cannot be fully traced: classify probable/possible, never confirmed.
- If a query cannot be parameterized (dynamic identifier): require an allow-list and reject unknown values; document this in the report.
- If tests fail after parameterization: fix the smallest cause and re-run; do not revert to concatenation to "make it pass".
- If `ORDER BY`/column injection is stylistic rather than data-driven: still require identifier allow-listing at the boundary.

## Output Format
Report: findings table (file, line, sink type, value origin, classification,
severity, evidence trace), fixes applied, remaining findings with blockers,
verification results, and any changes of behavior to expected query output.

## References
- CONTRACT.md §2 Skill Format.
- .claude/rules/sql.md — parameterize, LIMIT, transactions.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap test`, `cap verify`, `cap diff`.
- docs/review-engine.md §5 classification rules.