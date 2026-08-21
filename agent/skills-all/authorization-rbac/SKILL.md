---
name: authorization-rbac
description: Implement authorization — RBAC/ABAC, ownership checks, scope limits, middleware ordering. Use when adding roles, permissions, or tenant isolation.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Authorization (RBAC / ABAC)

## Model
- RBAC (roles → permissions) covers most apps: `user`, `admin`; permission sets `posts:read`, `posts:edit`, `users:manage`. Store role↔permission mapping in DB/config, check permission (not role) in code.
- ABAC when rules depend on context: `owner == requester`, `tenant_id == row.tenant_id`, time/day, resource state — via policy rows or a small evaluator.
- Never embed "is admin = true/false only"; apps grow — model permission granularity early (but add on need, don't pre-build all).

## Enforcement (3 places, never forget)
1. **Route middleware**: cheap coarse gate (authenticated + role) — fine for whole sections.
2. **Service layer (must-have)**: every mutation/relevant read re-checks permission + ownership with current resource (`row.owner_id == user.id` or `user.can('edit', resource)`). Route middleware alone = IDOR.
3. **DB level (defense in depth)**: tenant/user filter in query — never `WHERE id = ?` without scoping to org/owner; prevents multi-tenant leakage even if service missed.

## Ownership pattern
- `created_by` / `owner_id` column; service queries must join that filter. For shared resources: sharing table (grants) checked in service.
- Impersonation/support tools: explicit `impersonating` context + audit trail, never silent role-swap.

## Common bugs
- Checking only in middleware but fetch by id happens later (IDOR); role string compares (`=== 'admin'`) duplicated everywhere instead of permission helper; missing check in one of parallel endpoints (batch delete); cache serving stale perms.

## Checklist
- [ ] Permission checks at service level, not just middleware
- [ ] Ownership scoping in DB queries (tenant/owner)
- [ ] No role-string literals in business logic
- [ ] Batch operations check per-item
- [ ] Audit log for permission changes