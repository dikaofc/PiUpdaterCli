---
name: orm-best-practices
description: Use ORMs without the footguns — eager loading, transactions, shape mapping, generated SQL verification, migrations.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# ORM Best Practices

## Purpose check
ORM = productivity for CRUD; it is NOT the engine. Know what SQL it emits (`log: true`, `EXPLAIN` on suspicious queries) — every N+1 and cartesian product is visible in the generated join.

## Eager loading (the #1 fix)
- Load related collections in one query: Sequelize `include`, Prisma `include/select`, SQLAlchemy `selectinload`/`joinedload`, TypeORM `relations`.
- Lazy loading per-row (`user.posts` in a loop) = N+1 = perf bug. Audit: count queries per request (query logger counts; identity-map dedupe makes it invisible — log actual SQL).
- `selectinload` beats `joinedload` for collections (avoids row multiplication across multiple relationships — cartesian joins).

## Transactions
- Method/unit-of-work boundary, not per-row ops: `db.transaction(async () => {...})` around the whole aggregate change.
- Read-then-write races: same patterns as SQL — `lock`/`FOR UPDATE` on the row being modified; optimistic locking via `version` column when applicable.
- Never keep a transaction open across external calls (network, email) — commit early, then side-effect.

## Shape discipline
- Return network shapes from DTOs/selects (`select: {id,name}`, `columns`), not full entity rows — leaks hidden columns, bloats payloads.
- Map to domain/API types at the boundary; don't hand entity objects to serializers.
- `softDelete`/`paranoid`: read the flag semantics — can hide data from raw queries; prefer explicit `deleted_at IS NULL` filtering or document layering.

## Migrations & schema drift
- ORM-generated migrations acceptable but reviewable (same rules as `sql-migrations`); never `sync({force})`/`dropSchema` in prod — DDL like that wipes data.
- Constraint definitions (unique index on (user_id, slug)) live in schema — enforce in app plus DB (belt & suspenders).

## Checklist
- [ ] Eager loads for every relation on hot paths
- [ ] Query count ≤ 1-2 per request (verified, not assumed)
- [ ] Transactions at aggregate level; no I/O inside
- [ ] DTO/select shapes at boundaries
- [ ] No force-sync migrations in prod