# Pattern: Secure Database

## Problem

Data access must be injection-safe, tenant-isolated, transactionally correct, and
least-privileged.

## Design

1. **Parameterized queries everywhere.** No string concatenation into SQL; ORM
   query builders used for dynamic parts (`skills/database/query-safety.md`,
   `orm-security.md`).
2. **Tenant/row isolation in queries.** Every multi-tenant query filters by tenant
   or uses row-level security; never rely on app-level filtering alone
   (`database-access-control.md`).
3. **Least-privilege DB account.** App account: CRUD on needed tables only; no
   DDL; separate migration account (`database-access-control.md`).
4. **Transactions with correct isolation** for multi-write operations; handle
   races with constraints/atomic ops (`transaction-analysis.md`,
   `transaction-integrity.md`, `race-condition-database.md`).
5. **Bounded queries:** limits, keyset pagination; no unbounded scans
   (`query-safety.md`).
6. **No schema/data leakage in errors** (`database-error-leakage.md`).
7. **Backups encrypted and access-controlled** (`backup-security.md`).

## Verify

- Query audit (grep for string-built queries) + negative tests (wrong tenant id
  returns nothing; SQL metacharacters are inert).

## Anti-Patterns

- `$where`/`raw()` string queries; loading all rows then filtering in code;
  storing tenant_id only in session and trusting it.

## Related

- `../skills/database/*`
- `../checklists/database.md`
