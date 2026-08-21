---
name: database-modeling
description: Design database schemas — normalization, keys, constraints, audit fields, soft vs hard delete, polymorphic pitfalls.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Database Modeling

## Core design
- **IDs**: surrogate `BIGSERIAL`/`BIGINT` or UUIDv7 (ordered, index-friendly) — UUIDv4 fine for low-write but costs index locality. Decide once; never business data (email/name) as PK.
- **Constraints are the schema's contract**: `NOT NULL` where true, `CHECK` for domain ranges, `UNIQUE` for natural keys, FKs `ON DELETE RESTRICT` (surprises avoided) or cascade documented.
- **Normalize to 3NF**, then denormalize deliberately for hot reads (counters, digest columns) *with* a write-path owner (service/batch that keeps it consistent). Every denormalized value = a consistency job.
- Timestamps: `created_at` + `updated_at` (trigger or ORM auto), `created_by` for audit when meaningful; `tz` column when needed (store UTC, render local).

## Relationships
- many-to-many via join table with its own PK; one-to-one only for hot/cold split (messages vs content) — usually premature.
- Soft delete: `deleted_at` only when hard-delete breaks referential history; index `(deleted_at IS NULL)` partial; soft-deleted rows still violate unique (add `deleted_key` salt column). Hard delete by policy (GDPR) with cascade plan.
- Polymorphic FKs (`item_id` + `item_type`) = no FK integrity — prefer join tables per type or interfaces (PG), or accept + document.

## Evolution-readiness
- Nullable-new-column pattern: every additive migration starts nullable → backfill → NOT NULL (see `sql-migrations`).
- Enum-as-extension: prefer lookup/check over hard enum types unless tiny and versioned. JSONB for genuinely variable attributes (search indices trade write-cost).

## Checklist
- [ ] Constraints everywhere values are bounded
- [ ] No business field as PK; id strategy decided
- [ ] Denormalization has an owner + sync path
- [ ] Soft deletes: partial index + salt handling
- [ ] Audit columns present where required