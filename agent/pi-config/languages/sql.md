# Language Guide: SQL

Security and correctness analysis notes for SQL: queries, stored procedures,
schemas, and database configuration.

## Dangerous Patterns

- **String-concatenated queries** in any language calling into SQL — SQL
  injection (`sql-injection.md`). The injection surface is the calling code.
- **Dynamic identifiers** (table/column names) built from input — identifier
  injection; allow-list identifiers (`query-safety.md`).
- **`LIKE` patterns** from user input — wildcard injection and performance
  issues; escape `%`/`_` (`query-safety.md`).
- **`ORDER BY` / `LIMIT` / `OFFSET`** from user input — injectable clauses;
  validate against allow-lists and numeric ranges (`api-pagination.md`).
- **`BETWEEN`/range confusion**, timezone-dependent comparisons — correctness
  bugs (`boundary-validation.md`).
- **Aggregation without `GROUP BY` discipline**, `NULL` handling in
  `NOT IN` — correctness bugs (`business-rule-analysis.md`).
- **`SELECT *`** — data exposure (`api-data-exposure.md`).
- **Stored procedures with dynamic SQL** (`EXEC`/`EXECUTE IMMEDIATE` with
  concatenation) — injection inside the DB (`query-safety.md`).

## Common Mistakes

- Unbounded queries (no LIMIT) — exhaustion (`resource-exhaustion.md`).
- Reading without row-level/tenant filtering (multi-tenancy)
  (`database-access-control.md`).
- Non-parameterized `IN` lists built by string join.
- Implicit type coercion in comparisons (`type-confusion.md`).
- Over-broad database privileges (app user with DDL) (`database-access-control.md`).

## Input Handling

- Always parameterize values; never concatenate literals.
- Validate and allow-list any dynamic SQL component.

## Schema & Configuration

- Constraints as correctness guards: `CHECK`, `UNIQUE`, `FOREIGN KEY`,
  `NOT NULL` — enforce invariants the app relies on
  (`transaction-integrity.md`).
- `ROW LEVEL SECURITY` (PostgreSQL) for tenant isolation
  (`database-access-control.md`).
- Indexes on filtered columns; avoid full scans on hot paths
  (`performance/*`).
- Transactions with correct isolation levels (`transaction-analysis.md`).

## Concurrency

- `SELECT ... FOR UPDATE` / `SKIP LOCKED` for atomic reads-then-writes
  (`race-condition-database.md`, `atomicity-analysis.md`).
- Unique constraints to stop duplicate races (`duplicate-operation.md`).
- Deadlocks from lock ordering (`deadlock-analysis.md`).

## Errors

- Database error messages to clients leak schema — map to generic errors
  (`database-error-leakage.md`).

## Testing

- SQL injection tests per query; property tests for predicates; migration tests;
  isolation tests for multi-tenancy (`testing/*`).

## Related

- `../skills/database/*`
- `../languages/*` (query construction in each language)
