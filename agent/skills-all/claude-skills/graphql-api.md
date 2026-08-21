---
name: graphql-api
description: Design a GraphQL schema with resolvers, N+1 fixes, and depth limiting.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [graphql, api]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# GraphQL API

## Objective
Expose a typed, safe GraphQL surface that avoids the classic performance traps.

## Preconditions
- `cap repo` run; existing resolvers/schema found (`cap explore <graphql|schema|resolver>`).

## Workflow
1. Run `cap explore` for the schema and resolver tree.
2. Co-locate resolvers with data loaders; batch with DataLoader to kill N+1.
3. Add query depth/complexity limiting and persisted queries to block abuse.
4. Define clear error extensions and nullability; avoid nullable where integrity matters.
5. Add auth/rate limits at the resolver or gateway (see rate-limiting).
6. Record schema conventions with `cap memory add`.

## Verification
- [ ] No N+1 (loaders batching).
- [ ] Depth/complexity limit enforced.
- [ ] Errors typed via extensions.
- [ ] Auth/rate-limit present at gateway or resolver.

## Failure Handling
- If over-fetching, narrow fields or use `@include`.
- If cyclic queries, cap depth.

## Output Format
GraphQL design: schema, loaders, limits, error model, and auth placement.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
