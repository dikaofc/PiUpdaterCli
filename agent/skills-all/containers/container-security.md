# Skill: Container Security

## Purpose

Analyze container runtime security: isolation, namespaces, seccomp, network
policy, and runtime attack surface.

## Scope

- Included: runtime isolation, seccomp/AppArmor, network policies, writable
  layers, host mounts.
- Excluded: image content (`image-security.md`).
- Layers: container runtime.

## Trigger Conditions

- Runtime config changes.
- Claims of "isolated" to verify.

## Inputs

- runtime configs (k8s/containerd/docker)
- host configs

## Investigation Method

1. Identify entry points: runtime starts.
2. Identify trust boundaries: container → host.
3. Track relevant data: mounts/caps.
4. Identify validation: isolation controls.
5. Identify security-sensitive operations: host interaction.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: escape surface.
10. Validate the finding: config review.

## Evidence Requirements

- E1: runtime config.
- E2: isolation gap.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local config review; no hostile runtime tests.

## Root Cause

- Broad caps; no seccomp; host mounts.

## Impact

- Container escape, host compromise.

## Remediation

- Seccomp/AppArmor; drop caps; read-only rootfs; network policies;
  restricted mounts.

## Regression Test

- Config assertions on isolation settings.

## Common False Positives

- Controls at platform level (verify).

## Related Skills

- `docker-security.md`
- `container-orchestration.md`
- `../infrastructure/process-permissions.md`

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

- CIS Docker/Kubernetes Benchmarks
- OWASP Container Security guidance
