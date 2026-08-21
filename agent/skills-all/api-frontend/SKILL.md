---
name: api-frontend
description: Talk to APIs correctly from the frontend — fetch patterns, error handling, abort, retry, auth headers, optimistic updates.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Frontend

## Fetch layer
- One `fetchClient(baseUrl, {auth, retry})` wrapper: JSON headers, timeout via AbortController+scheduler, unified error type (`{status, data, message}`), network vs HTTP error distinction.
- Never `fetch` raw in components — a client layer keeps auth + error handling in one place; components consume typed methods.
- Types: derive from OpenAPI (openapi-typescript) or zod schema — no hand-duplicated interfaces.

## Error handling
- Distinguish: network down (retry later), 4xx (show message), 5xx (retry + alert), timeout (cancel UI state).
- Surface errors where the user can act; log details (status, path, trace) to observability.
- Retry policy: idempotent GETs — 2-3 with backoff; POSTs never auto-retry (duplicate risk) unless idempotency key.
- Timeouts: reads 10s, writes 30s default; uploads longer.

## Auth
- Token in memory/refresh flow; `Authorization: Bearer` via interceptor; refresh-on-401 once (queue concurrent 401s to single refresh); logout on refresh failure.
- Never tokens in localStorage if XSS risk matters — memory + refresh cookie preferred; HttpOnly cookies for web.

## UX patterns
- Optimistic update: apply pending state, rollback on error (Track failure via error state in UI).
- Idempotency keys for critical writes (`Idempotency-Key` header).
- Cache reads with revalidate (stale-while-revalidate); abort canceled requests (search-as-you-type) — `AbortController` signal from active request.

## Checklist
- [ ] Single client layer, typed responses
- [ ] HTTP vs network errors distinguished
- [ ] No auto-retry on writes
- [ ] Auth refresh safe under concurrency
- [ ] Cancellation honored (abort on unmount/navigation)