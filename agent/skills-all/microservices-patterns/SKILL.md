---
name: microservices-patterns
description: Apply microservice patterns — boundaries, sync vs async, service discovery, observability, SQLite/DATA ownership, failure isolation.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Microservices Patterns

## Start with the question
Not "how micro" — "what breaks with a monolith?" If deploy coupling or team-scale is the pain, split; otherwise a modular monolith (clear internal boundaries, single deploy) wins for 2-15 devs. Extract services along **failure domains** (billing, auth, search), not layers (api→service→data).

## Ownership
- Each service owns its data: private schema/table per service, no cross-service joins (API call or event for aggregation). One database per team; shared-DB coupling = distributed monolith.
- Contracts: thrift/protobuf/OpenAPI versioned; schema registry + compatibility checks in CI. Breaking change = new version, dual-run, kill old.

## Communication
- Sync (REST/gRPC): request-response, retries with timeouts + circuit breaker (room for fallback: 500-with-cache-last).
- Async (queue/event): `background-jobs` patterns; events carry ids not blobs; outbox pattern for reliable event emission (write event row in same DB tx as business row → relay → queue).

## Failure isolation & resilience
- Circuit breaker per dependency (open on 50% errors/5s window → fast-fail); bulkhead thread pools per dependency class; timeouts everywhere (connect ≤ 3s, request ≤ 10s, overall budget).
- Graceful degradation: degrade > fail (serve cached/empty with indicator); degradation tested (chaos-lite: kill one dep in CI occasionally).
- Idempotent consumers; dead-letter + alert.

## Discovery/config/observability
- DNS/registry (Kubernetes service, Consul) — app code reads from env; config via env/secret manager (no config service dependency at boot).
- **Observability is the tax**: every request carries `trace_id` (W3C traceparent); logs structured + correlation; metrics per service (RED: rate/errors/duration); dashboards per service; distributed tracing (OTel) at boundaries. Without it, debugging = archaeology.

## Checklist
- [ ] Each service owns schema; no cross joins
- [ ] Versioned contracts + CI compat check
- [ ] Circuit breakers + timeouts on all calls
- [ ] Outbox for event reliability
- [ ] Trace propagation + per-service RED metrics