---
name: monitoring-observability
description: Build monitoring and observability — metrics, logs, traces, dashboards, alerts that page vs notify. Use when setting up or fixing alerting.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Monitoring & Observability

## The three pillars
- **Metrics** (numbers): RED for request services (Rate, Errors, Duration), USE for infra (Utilization, Saturation, Errors); latency percentiles (p50/p95/p99) not averages.
- **Logs** (events): structured JSON with `trace_id`, `request_id`, service, env; levels discipline (info/error); high-volume → sampled tails + retention tiering.
- **Traces** (correlation): distributed tracing across services — `traceparent` propagation (`microservices-patterns`); attach spans to DB/queues/external calls.

## Golden signals → alerting
- **Page (few)**: SLO breach (error rate > 1% for 10 min), latency SLO, availability down, backup/RPO at risk, disk 90%+. Each alert = documented runbook + owner + severity.
- **Notify (most)**: deprecations, quota 70%, batch lag — dashboard/watch, not pager.
- Alert rules: threshold NOT spike-noise; avoid MTTD inflation (fire too often = ignored); `for:` duration + `severity` set; silence/ack workflow.

## Dashboards
- Per service: requests, errors%, latency percentiles, saturation (queue depth/CPU); per infra: FS, memory, connections; SLO board (burn rate).
- A dashboard is a hypothesis (`caching-strategies` hit-rates, hot-key visibility) — review quarterly, prune dead charts.

## Log pipeline essentials
- Correlation IDs injected at entry (middleware), forwarded to child logs/queues; sensitive fields redacted (PII — emails, tokens) at emission, not at query.
- Shipping: agent (otlp/filebeat) → collector → store (Loki/ELK/OTel backend); retention/policies by class (access 90d, debug 7d).

## Tooling options
- Hosted: Grafana Cloud/Datadog/Sentry; OSS: Prometheus+Mimir+Tempo+Loki+Grafana. Sentry for error tracking (stack traces, breadcrumbs, release tagging).
- Keep one tracing backend — mixed = correlation debt.

## Checklist
- [ ] RED/USE metrics exported per service
- [ ] Page alerts only for SLO/availability — with runbooks
- [ ] trace_id everywhere; redaction in place
- [ ] Dashboards pruned; SLO burn-rate visible
- [ ] Alert targets rotated; playground to test