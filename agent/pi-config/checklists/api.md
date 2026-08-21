# Checklist: API

Per-endpoint verification checklist (see `../workflows/api-audit.md`).

## Per Endpoint

- [ ] Authentication enforced (401/403 on missing/invalid credentials)
- [ ] Authorization at function level (BFLA) and object level (BOLA)
- [ ] Input validated at the boundary: type, format, size, schema
- [ ] Object ownership verified for every object id reference
- [ ] Rate limiting present per identity, not bypassable
- [ ] Idempotency for state-changing operations (or safe duplicates)
- [ ] Pagination bounded and correctly ordered
- [ ] Response contains only required data (no over-fetch)
- [ ] Error responses do not leak internals or auth details
- [ ] State transitions validated
- [ ] Concurrency safe (no races on shared state)
- [ ] Logging without sensitive data

## Protocol Specific

- [ ] GraphQL: introspection disabled in prod; depth/aliasing limits; field-level
  auth (`graphql-security.md`)
- [ ] WebSocket: origin checked; auth on connect; message validation
  (`websocket-security.md`)
- [ ] gRPC: reflection disabled; auth interceptors; message size limits
- [ ] Versioning: old versions still protected; no accidental exposure
  (`api-versioning.md`)

## Tests

- [ ] Negative tests per endpoint (unauthenticated, wrong role, other-tenant id,
  malformed body)
- [ ] Boundary tests (max sizes, empty payloads, duplicate ids)
- [ ] Contract/schema tests match implementation

## Related

- `../skills/api/*`
- `../checklists/authorization.md`
