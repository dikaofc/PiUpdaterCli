# Checklist: Database

Verification checklist for database access and design.

## Access Control

- [ ] Application DB account least-privilege (no DDL/DROP in prod app account)
  (`database-access-control.md`)
- [ ] Row-level security / tenant isolation enforced in queries, not only in app
  code
- [ ] No direct DB exposure to the network (`network-exposure.md`)
- [ ] Backups encrypted and access-controlled (`backup-security.md`)

## Query Safety

- [ ] All queries parameterized; no concatenation (`query-safety.md`)
- [ ] ORM usage does not allow raw string queries or mass assignment
  (`orm-security.md`)
- [ ] Aggregations/limits prevent unbounded scans
- [ ] Query results limited (no full-table fetch by default)

## Transactions & Concurrency

- [ ] Transactions wrap related writes with correct isolation
  (`transaction-analysis.md`)
- [ ] No partial writes on failure; rollback verified
  (`transaction-integrity.md`)
- [ ] Race conditions handled: unique constraints, atomic ops, locking
  (`race-condition-database.md`)

## Errors

- [ ] DB errors do not leak schema, SQL, or data to clients
  (`database-error-leakage.md`)
- [ ] Connection pooling configured; no connection leaks (`connection-leak.md`)

## Related

- `../skills/database/*`
- `../checklists/backend.md`
