# Pattern: Secure Authorization

## Problem

Callers must only perform operations they are allowed to perform, on objects they
are allowed to touch — enforced server-side.

## Design

1. **Default deny.** Unknown roles/permissions → deny. Authorization is an explicit
   allow decision, not an absence of a deny.
2. **Centralized enforcement.** A single authorization layer (middleware,
   decorators, policy engine) rather than scattered inline checks
   (`skills/authorization/access-control-analysis.md`).
3. **Per-operation checks.** Authorization is evaluated for each operation, not
   only at the route level; object-level checks are separate from function-level
   checks.
4. **Object ownership.** Every object id from a client is resolved and checked
   against the caller's ownership/tenant before use
   (`skills/authorization/resource-ownership.md`, `idor-analysis.md`).
5. **Tenant isolation in queries.** Multi-tenant data is filtered at the query
   layer, not only in service code (`skills/database/database-access-control.md`).
6. **Least privilege roles.** Roles grant the minimum permissions; no silent
   inheritance surprises (`role-analysis.md`, `permission-inheritance.md`).
7. **Re-verification on privilege change.** Authorization evaluated at the time of
   the operation (not cached from login) when roles/permissions can change.

## Verify

- Test matrix: endpoint × role × object-owner; lowest-privilege-denied tests
  (`skills/testing/negative-testing.md`).
- `../checklists/authorization.md`.

## Anti-Patterns

- Frontend gating; client-provided roles/ownership ids; relying on route naming;
  object-level checks missing because function-level checks exist.

## Related

- `../skills/authorization/*`
- `../patterns/secure-api.md`
