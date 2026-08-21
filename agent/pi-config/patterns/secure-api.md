# Pattern: Secure API

## Problem

API endpoints must validate input, enforce auth and authorization, and behave
correctly under concurrency, retries, and abuse.

## Design

1. **Validate at the boundary.** Schema/type/format/size validation on every
   endpoint (`skills/api/api-schema-validation.md`,
   `api-input-boundaries.md`).
2. **Auth + authorization per endpoint.** No unauthenticated state-changing
   endpoints; per-object ownership checks (`api-authentication.md`,
   `api-authorization.md`).
3. **Idempotency keys** for state-changing operations so retries are safe
   (`api-idempotency.md`, `duplicate-operation.md`).
4. **Rate limiting** per identity and per endpoint class; bypass-resistant
   (IP + account + behavior) (`api-rate-limiting.md`).
5. **Bounded pagination** with stable ordering; no enumeration leaks
   (`api-pagination.md`).
6. **Least data exposure** in responses; explicit response schemas
   (`api-data-exposure.md`).
7. **Safe error handling:** generic client-facing errors; full details logged
   server-side (`api-error-handling.md`).
8. **Versioning** with continued protection of old versions (`api-versioning.md`).

## Verify

- Per-endpoint 12-point rule (`../workflows/api-audit.md`,
  `../METHODOLOGY.md` API rule).
- Negative/boundary tests per endpoint.

## Anti-Patterns

- Accepting any object shape; unbounded lists; non-idempotent retries; exposing
  internal ids/models verbatim.

## Related

- `../skills/api/*`
- `../checklists/api.md`
