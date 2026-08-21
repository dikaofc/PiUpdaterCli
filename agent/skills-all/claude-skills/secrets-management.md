---
name: secrets-management
description: Store and inject secrets via a vault/manager — never in code or env files.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [secrets, security]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Secrets Management

## Objective
Eliminate hardcoded secrets and centralize rotation and access.

## Preconditions
- `cap repo` run; current secret usage reviewed (`cap search <secret|password|api_key|token>`).

## Workflow
1. Run `cap search` for hardcoded credentials and insecure env usage.
2. Move every secret to a manager (Vault/cloud secret store) with least-privilege access.
3. Inject at runtime via the platform; never commit `.env` with real values (gitignore + example only).
4. Enable rotation and versioning; apps read the latest version with fallback.
5. Audit access and alert on anomalous secret reads.
6. Record the secret inventory with `cap memory add`.

## Verification
- [ ] No secrets in source or committed files.
- [ ] All from manager with least privilege.
- [ ] Rotation enabled.
- [ ] Access audited + alerted.

## Failure Handling
- If a secret leaked, rotate immediately and purge history.
- If manager down, use cached sealed copy with break-glass.

## Output Format
Secrets design: inventory, manager integration, rotation, and the purge/rotation plan.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
