---
name: api-testing
description: Test APIs systematically — happy/error cases, auth matrix, contract validation, load smoke, spec-driven testing.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Testing

## Structure
- Spec-driven (OpenAPI) generates clients + expectations: `schemathesis`/`dredd` fuzz against spec; contract suite from spec (`rest-api-design`).
- Per-endpoint tests: success (happy + params), validation (malformed payloads → 400/422 field errors), auth (401 no token, 403 wrong role, owner vs non-owner), edge (empty collections, pagination caps, huge ids).

## Auth matrix (the one teams skip)
- For each route: unauthenticated, user (non-owner), owner, admin — assert 401/403/200 + data isolation (tenant A never sees tenant B rows).
- Role escalation: user calling admin endpoints; privilege via query param manipulation (`?isAdmin=true`).
- Tokens: expired, wrong audience/issuer, revoked — each rejected cleanly.

## What to assert
- Status codes exact (`rest-api-design` codes), envelope shape (error `code`/`message` stable), idempotency (replay POST with same key → same result/no dup), pagination (limits + cursor continuity).
- Side effects: row counts before/after (DB assert), events emitted (queue probe).

## Tooling
- Supertest (node) / pytest + httpx (python) in-app; Postman/Insomnia collections for manual + Newman CI smoke; K6/Artillery for load smoke on critical reads (100 req/s, p95 under target).

## Load smoke (cheap edition)
- `k6` run: N concurrent users over 30-60s, assert error rate < 0.5% + p95 budget; catch N+1s/index bombs before traffic.

## Checklist
- [ ] Per-endpoint happy + validation + auth matrix
- [ ] Data isolation verified (cross-tenant)
- [ ] Envelope/codes asserted exactly
- [ ] Idempotency + pagination covered
- [ ] Load smoke wired for hot paths