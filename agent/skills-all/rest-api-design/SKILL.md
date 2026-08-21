---
name: rest-api-design
description: Design REST APIs — resources, verbs, status codes, pagination, versioning, filtering, error envelope, OpenAPI.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# REST API Design

## Resources & verbs
- Nouns plural resources (`/users`, `/users/42/orders`), verbs as HTTP methods: GET read, POST create (collection), PUT full replace, PATCH partial, DELETE. Only fall back to `/action` endpoints for non-CRUD (search, upload).
- Nesting max 2 levels; sub-resources = relationships. Filters via query params (`?status=active&limit=50&cursor=...`), not path.
- Idempotency: GET/PUT/DELETE idempotent; POST not — support `Idempotency-Key` for payments/orders.

## Status codes
- 200 GET/PUT, 201 POST (with `Location`), 202 accepted (async), 204 DELETE.
- 400 invalid request, 401 unauthenticated, 403 forbidden, 404 missing (distinguish from 403 to avoid info leak), 409 conflict (version/duplicate), 422 domain validation (semantically invalid), 429 rate-limited, 5xx server.
- Never return 200 with error body for failed operations.

## Error envelope
```json
{ "error": { "code": "email_taken", "message": "Email already registered", "field": "email", "details": {}, "trace_id": "..." } }
```
- Stable machine `code`; message for humans; `details` for form fields; trace_id links logs.

## Pagination & filtering
- Cursor-based for high-traffic (stable under inserts), offset only for small sets; `Link` header or `{"next_cursor"}` in body; default + max limits (`limit=50` default, cap 100).
- Always cap; return `total` only when needed (costs counts).

## Versioning & evolution
- Prefer additive evolution (never change meaning) → v1 lasts; when breaking, `/v2/` prefix or Accept header; deprecate with 410 + `Deprecation` header + `sunset` date.
- OpenAPI 3.1 as contract: `openapi-typescript` for client types; validate requests with a schema (see `api-validation`); document auth schemes, pagination, errors once.

## Checklist
- [ ] Naming consistent, nested ≤ 2
- [ ] Status codes exact (no 200-for-error)
- [ ] Error envelope with code+message+field
- [ ] Pagination capped + cursor
- [ ] OpenAPI matches implementation (CI check)
- [ ] Idempotency for money/order writes