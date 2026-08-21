---
name: container-orchestration-kubernetes
description: Run workloads on Kubernetes — manifests, deployments, services, ingress, probes, resource limits, RBAC, storage.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Kubernetes

## Core objects (mental model)
- `Deployment`: desired state (replicas, image, strategy); `Service`: stable VIP/selectors; `Ingress`: external HTTP routing (when API server exposes; or `LoadBalancer` on bare-metal/MetalLB).
- `ConfigMap`/`Secret` (base64 only!, size ≤ 1MiB — really for config not secret blobs); `PVC`/`StorageClass` for state; `Namespace` = failure domain + RBAC boundary.
- `kubectl get/describe/logs/exec`, `-o wide`, JSONPath when scripting (`kubectl get pods -o jsonpath`).

## Manifest discipline
- Declarative only: `kubectl apply -f` from git (GitOps — ArgoCD/Flux preferred); never ad-hoc `kubectl run` in prod.
- Resource requests/limits on **every** container (CPU requests 100m-1, memory real usage + headroom) — no limits → evictions/OOM chaos; requests ≠ limits mismatch causes throttling.
- Probes: `livenessProbe` (restart path), `readinessProbe` (traffic gate — same check as `/healthz` distinct from `/readyz`), `startupProbe` for slow apps (first).
- Strategy: `RollingUpdate` default for stateless (maxSurge/maxUnavailable), `Recreate` for locked stores; version pinning image tags (never `:latest`).

## Networking & security
- NetworkPolicy (deny-all default then allow), ServiceAccount per workload with minimal RBAC (no default SA), secrets via CSI/ExternalSecret/SOPS.
- Ingress: TLS termination, annotations (nginx/traefik), paths; avoid exposing control-plane.
- Resource admission: `LimitRange`/`ResourceQuota` per namespace; `priorityClassName` for critical.

## Stateful & ops
- StatefulSets (stable identity/order) only for legacy; today prefer operators/cloud services for Kafka/DB — operator ownership FTW.
- Node: taints/tolerations for dedicated pools; HPA (`autoscaling` on CPU or custom metrics); cluster-autoscaler working with reservations.

## Daily ops
- Rollout: `kubectl rollout status/undo`; logs: `-f`, `--tail`, namespaced via label `-l app=x`.
- Debugging: describe → events (transient startup races), exec into pod with matching distro, dig DNS `kubectl get svc` (service discovery failure = DNS/selector).
- Upgrade cadence: patch versions monthly, minor on N-1, drain nodes with `kubectl drain` honoring PDBs.

## Checklist
- [ ] Requests/limits everywhere; probes all three set
- [ ] GitOps deploy; no imperative prod changes
- [ ] RBAC least-privilege; NetworkPolicy enforced
- [ ] Image tags pinned; rolling strategy sane
- [ ] PDBs for stateful/replicas>1