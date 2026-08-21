# Checklist: Authorization

Verification checklist for access control.

## Enforcement

- [ ] Authorization enforced server-side on every protected operation
  (`server-side-authorization.md`)
- [ ] No reliance on frontend checks, hidden UI, disabled buttons, route naming,
  or client-provided roles/ownership
- [ ] Enforcement at the object level, not only the route level
- [ ] Default-deny: unknown roles/permissions denied

## Object & Function Level

- [ ] Object ids validated for ownership on every access (IDOR/BOLA)
  (`idor-analysis.md`, `bola-analysis.md`)
- [ ] Function-level checks on every admin/privileged operation (BFLA)
  (`bfla-analysis.md`, `vertical-privilege-escalation.md`)
- [ ] Horizontal escalation impossible (tenant/user A cannot access B's data)
  (`horizontal-privilege-escalation.md`)
- [ ] Multi-tenant queries filter by tenant on every query path
  (`database-access-control.md`)

## Roles & Permissions

- [ ] Role analysis: least privilege, no over-broad roles (`role-analysis.md`)
- [ ] Permission inheritance verified; no accidental privilege grant
  (`permission-inheritance.md`)
- [ ] Ownership model defined and enforced for every resource
  (`resource-ownership.md`)
- [ ] Admin functions protected by role + re-authentication where appropriate
  (`admin-function-protection.md`)

## Tests

- [ ] Negative tests: lowest privilege that should be denied is denied
  (`negative-testing.md`)
- [ ] Authorization tests exist per endpoint × role matrix
- [ ] Concurrency: authorization cannot be bypassed by racing state changes

## Related

- `../workflows/auth-audit.md`
- `../skills/authorization/*`
- `../checklists/api.md`
