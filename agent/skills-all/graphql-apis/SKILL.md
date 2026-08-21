---
name: graphql-apis
description: Design and build GraphQL APIs — schema, resolvers, N+1 prevention, errors, auth, pagination, subscriptions.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# GraphQL APIs

## When
- Client needs flexible shaped data, multiple clients with different views, mobile+web. For simple CRUD with one client, REST beats GraphQL complexity.

## Schema first
- `schema.graphql` is the contract: types, `Query`/`Mutation` roots, `@deprecated` for evolution. Names: PascalCase types, camelCase fields; verbs for mutations (`createOrder`, not `newOrder`).
- Avoid over-fetching hazards: every field must be resolvable in reasonable steps; fields that require expensive joins get cost/paging (see below).
- Nullability: non-null where guaranteed; nullable where failure possible — never lie with non-null (client crashes on partial).

## Critical: N+1
- **DataLoader** (per-request cache+batching): one `load(id)` per parent row; keyed by parent. Never resolve child rows with per-parent queries.
- Field resolvers: parent ID → `dataloader.load(parentId)`; batch query `WHERE id IN (...)`.
- Watch: list-of-X inside list of Y doubles as pagination drain — cap nested pagination.

## Errors
- GraphQL returns 200 with `errors[]` — add `extensions: {code}` stable codes; partial success semantics documented; mutations: fail atomically (return null not partial).
- Input validation: scalar types + custom scalars (email, DateTime via codec) — or arguments map.

## Auth & permissions
- Context carries user; resolver-level checks (same rules as REST `authorization-rbac`); field-level visibility for sensitive fields (email visible only to self/admin); directives (`@auth(requires: ADMIN)`) custom-linked to resolver check.
- Never leak existence via error differences (404 vs 403 in errors[]).

## Pagination (Relay-style)
- Connection spec: `edges { node }` + `pageInfo { hasNextPage endCursor }` — stable cursors (opaque base64 of id+sort); `first/after` params.

## Subscriptions
- WebSocket/SSE transport; auth in handshake; reconnection + missed-event strategy documented; keep payloads small.

## Checklist
- [ ] DataLoader on all record lists (no N+1)
- [ ] Schema = source of truth, generated types
- [ ] error codes with extensions
- [ ] Auth in resolvers + field visibility
- [ ] Pagination on every list
- [ ] Subscriptions handle reconnects