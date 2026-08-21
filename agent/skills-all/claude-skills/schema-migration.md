---
name: schema-migration
description: Write safe, reversible migrations with expand/contract and backfills.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [migration, database, devops]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Database Migrations

## Objective
Evolve schema without downtime or data loss, deployable independently of code.

## Preconditions
- `cap repo` run; migration tool and current schema reviewed (`cap explore <migration|schema>`).

## Workflow
1. Run `cap explore` for the migration runner and current schema state.
2. Use expand/contract: add new column/table first, backfill, then switch reads, then drop old.
3. Make each migration idempotent and reversible (down step); test both directions.
4. Backfill in batches to avoid long locks; throttle on large tables.
5. Deploy migrations before code that depends on them (forward-compatible).
6. Record the migration plan with `cap memory add`.

## Verification
- [ ] Each migration reversible + tested.
- [ ] No long locks (batched backfill).
- [ ] Code deployed after schema.
- [ ] Data verified post-migration.

## Failure Handling
- If a migration fails midway, ensure it is re-runnable.
- If downtime unavoidable, schedule a maintenance window.

## Output Format
Migration plan: expand/contract steps, backfill batches, rollback, and deploy order.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
