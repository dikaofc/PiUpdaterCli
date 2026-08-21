---
name: database-design
description: Design normalized, evolvable schemas with correct keys, indexes, and constraints.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [database, schema, design]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Database Design

## Objective
Produce a schema that enforces integrity at the DB layer and avoids common modeling mistakes.

## Preconditions
- `cap repo` run; ORM/migration tool and DB engine identified.
- Existing schema/migrations reviewed with `cap explore <migration|schema|model>`.

## Workflow
1. Run `cap explore` for existing models/migrations to match naming and engine conventions.
2. Identify entities and relationships; choose primary keys (stable surrogate or natural) and foreign keys with `ON DELETE` semantics.
3. Normalize to 3NF, then denormalize deliberately only for read hotspots (note the reason).
4. Add unique constraints, not-null, and check constraints for invariants the app must never violate.
5. Design indexes for the actual query patterns; avoid redundant or low-selectivity indexes.
6. Record the schema decisions and trade-offs with `cap memory add`.

## Verification
- [ ] Every FK has a defined delete rule.
- [ ] Invariants enforced by constraints, not only app code.
- [ ] Indexes match query patterns, not guesses.
- [ ] Migration is forward and backward compatible (expand/contract).

## Failure Handling
- If a constraint conflicts with legacy data, backfill then add it.
- If engine lacks a feature, model the invariant in a documented trigger or app check.

## Output Format
Schema: tables, keys, constraints, indexes, and the expand/contract migration plan with rollback.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
