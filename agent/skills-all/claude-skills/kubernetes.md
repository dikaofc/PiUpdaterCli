---
name: kubernetes
description: Author safe Kubernetes manifests — deployments, services, probes, limits, and rollouts.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: devops
  tags: [kubernetes, k8s, devops]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Kubernetes Manifests

## Objective
Provide deployable manifests with resource limits, readiness/liveness probes, and a safe rollout strategy.

## Preconditions
- `cap repo` run; container image and ports known (see docker skill).
- Cluster target and namespace understood.

## Workflow
1. Run `cap explore <deploy|k8s|helm|manifest>` to find existing manifests and conventions.
2. Define Deployment with explicit `resources.requests/limits` and a `securityContext` (non-root, readOnlyRootFilesystem).
3. Add `readinessProbe` and `livenessProbe` hitting a real health endpoint with sane thresholds.
4. Choose rollout strategy (`RollingUpdate` with maxUnavailable/maxSurge) and add a PodDisruptionBudget if multi-replica.
5. Expose via Service; keep config in ConfigMap and secrets in Secret, not in the manifest.
6. Record rollout and rollback steps with `cap memory add` (`kubectl rollout undo`).

## Verification
- [ ] Limits set; probes point at real endpoints.
- [ ] Runs non-root with read-only rootfs where possible.
- [ ] Rollback tested (rollout undo).
- [ ] No plaintext secrets in manifests.

## Failure Handling
- If probes cause crash loops, raise thresholds and check startup order.
- If quota blocks, right-size requests before raising limits.

## Output Format
Manifests: Deployment, Service, probes, limits, rollout policy, and the rollback command.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
