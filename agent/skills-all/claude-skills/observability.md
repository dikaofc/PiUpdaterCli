---
name: observability
description: Add metrics, traces, and structured logs so failures are diagnosable in prod.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [observability, metrics, tracing]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Observability

## Objective
Instrument a service with the three pillars so any incident has a clear signal.

## Preconditions
- `cap repo` run; framework and deployment target known.
- Existing instrumentation reviewed (`cap search <metric|trace|otel>`).

## Workflow
1. Run `cap explore` for request entry points and external calls to instrument.
2. Emit RED metrics (rate, errors, duration) on each endpoint and key dependency.
3. Propagate a trace context across async hops and outbound calls (OpenTelemetry-style).
4. Wire structured logs with a shared `trace_id` (see structured-logging).
5. Add dashboards/alerts on error rate and p95 latency; define SLOs.
6. Record signal inventory with `cap memory add`.

## Verification
- [ ] Each endpoint exposes rate/error/duration.
- [ ] Trace context crosses async + outbound.
- [ ] Logs carry trace_id.
- [ ] At least one alert on error rate/p95 exists.

## Failure Handling
- If tracing unsupported, fall back to correlation IDs in logs.
- If metrics too many, keep only SLO-relevant ones.

## Output Format
Observability plan: signals per endpoint, trace propagation, log linkage, and alert/SLO list.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
