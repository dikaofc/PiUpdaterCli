# Skill: Container Orchestration

## Purpose

Analyze orchestration security (Kubernetes, Nomad, Swarm): RBAC, network
policies, secrets, admission control, and pod security.

## Scope

- Included: cluster RBAC, network policies, secret handling, admission
  controllers, pod security standards.
- Excluded: single-container configs (`docker-security.md`).
- Layers: orchestration.

## Trigger Conditions

- Orchestration configs under review.
- Claims of "hardened cluster" to verify.

## Inputs

- k8s manifests/helm
- RBAC policies
- cluster configs

## Investigation Method

1. Identify entry points: API access.
2. Identify trust boundaries: pods ↔ cluster.
3. Track relevant data: N/A.
4. Identify validation: RBAC/policies.
5. Identify security-sensitive operations: cluster access.
6. Inspect authorization: RBAC correctness.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: cluster compromise.
10. Validate the finding: policy review.

## Evidence Requirements

- E1: orchestration configs.
- E2: RBAC/policy gap.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for cluster-wide gaps.

## Safe Reproduction

- Local manifest review; dry-run policy checks.

## Root Cause

- Over-broad RBAC; no network policies; default secrets handling.

## Impact

- Cluster takeover, cross-namespace access.

## Remediation

- Least-privilege RBAC; network policies; external secrets; admission
  policies.

## Regression Test

- Policy assertions in CI.

## Common False Positives

- Policies enforced at cluster level (verify).

## Related Skills

- `container-security.md`
- `../cloud/cloud-iam-analysis.md`
- `../cloud/deployment-security.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- Kubernetes security docs (RBAC, PSP→PSA)
- CIS Kubernetes Benchmark
