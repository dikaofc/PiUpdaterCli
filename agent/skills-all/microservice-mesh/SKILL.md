---
name: microservice-mesh
description: Decide whether to use a service mesh — envoy/istio/linkerd, traffic policies, mTLS, versus plain service-to-service.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Service Mesh

## The honest question
Mesh = sidecar proxies (Envoy/Istio/Linkerd) managing inter-service traffic at scale. **Default answer: don't** unless you have a concrete need:
- mTLS everywhere with zero app changes (compliance audit demands it),
- fine-grained traffic splitting (canary per-route, headers) for release engineering,
- centralized observability of service-to-service latency/RED without touching code,
- multi-cluster/tenant isolation pain is real.

## If you adopt
- **Linkerd** (data-plane-only, ~1/10 resource of Istio): lightweight, safer bet for most; mTLS + low-config. **Istio** when you need HTTP routing richness, fault injection, custom Envoy filters.
- Start with a *small* subset of services (pilot), not a fleet rollout — mesh is a culture change, not a config.
- Enforce: strict mTLS in your main namespace; leave permissive-guarded (audit, then strict after observability proves service identity).

## What mesh does NOT buy
- It doesn't fix N+1/timeouts/app bugs (`sql-query-optimization`, `background-jobs` still matter).
- It adds: latency (proxy hop), ops surface (sidecar lifecycle, Envoy config CP), memory footprint (each proxy ~15-50MB).
- Alternative modern option: **ambient/sidecar-less mesh** (Istio Ambient) reduces but doesn't remove proxy cost; or skip mesh and rely on:
  - mTLS via Linkerd-in-k8s or workload identity (SA token → cert),
  - observability via OTel spans + L7 proxy logs (envoy on LB).

## Rollout plan (if greenlit)
1. One namespace, ingress-only sidecars → 2. strict mTLS between two core svcs → 3. rollouts via TrafficSplit → 4. expand with dashboards + golden-signal alerts; measure added p95 vs target.

## Checklist
- [ ] Concrete driver documented (mTLS/split/observability)
- [ ] Pilot subset chosen; metrics baseline taken
- [ ] Resource/latency budget added to SLOs
- [ ] Rollback path (envoy off) rehearsed
- [ ] Team knows the proxy logs/CLI (curl to service → trace dashboards)