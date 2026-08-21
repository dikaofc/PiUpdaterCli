# Workflow: API Audit

## Purpose

Audit an API surface (REST, GraphQL, gRPC, WebSocket) against the per-endpoint
analysis rule: authentication, authorization, input validation, object ownership,
rate limiting, idempotency, pagination, data exposure, error handling, state
transitions, concurrency, logging.

## Method

### 1. Enumerate the Surface

- Collect all endpoints (routes, resolvers, RPC methods, WS handlers): `endpoint-discovery.md`.
- Collect the API spec (OpenAPI, GraphQL schema, protobuf) and note mismatches with
  the implementation.
- Classify each endpoint: auth required? which roles? which object ids?

### 2. Per-Endpoint Analysis (every endpoint)

Apply the 12-point rule (`../METHODOLOGY.md`):

1. Authentication — is it actually enforced? (`api-authentication.md`)
2. Authorization — function-level (BFLA) and object-level (BOLA) (`api-authorization.md`, `bola-analysis.md`, `bfla-analysis.md`)
3. Input validation — schema/type/size/format at the boundary (`api-schema-validation.md`, `api-input-boundaries.md`)
4. Object ownership — can a caller access objects they do not own? (`bola-analysis.md`, `resource-ownership.md`)
5. Rate limiting — present, per-identity, bypassable? (`api-rate-limiting.md`)
6. Idempotency — can the same operation run twice? (`api-idempotency.md`, `duplicate-operation.md`)
7. Pagination — bounded, correct ordering, no enumeration leak? (`api-pagination.md`)
8. Data exposure — response contains more than needed? (`api-data-exposure.md`)
9. Error handling — leaks internals or auth details? (`api-error-handling.md`)
10. State transitions — invalid transitions possible? (`state-transition-analysis.md`)
11. Concurrency — races on shared state? (`race-condition.md`)
12. Logging — sensitive data in logs? (`observability/logging-security.md`)

### 3. Protocol-Specific

- GraphQL: introspection, batching, depth/aliasing, field-level auth (`graphql-security.md`).
- WebSocket: origin checks, auth on connect, message validation (`websocket-security.md`).
- gRPC/RPC: reflection, auth interceptors, message size limits.

### 4. Verify & Report

- Reproduce suspicious endpoints safely (E3).
- Report per `../templates/vulnerability-report.md`; summarize per
  `../templates/audit-summary.md` with per-endpoint coverage status.

## Output

- Endpoint coverage table: each endpoint × 12 checks × status.
- Findings with evidence, severity, confidence, remediation, regression tests.

## Related

- `../skills/api/*` (all 15 API skills)
- `../skills/authorization/idor-analysis.md`
- `../checklists/api.md`
- `../workflows/auth-audit.md`
