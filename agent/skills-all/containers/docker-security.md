# Skill: Docker Security

## Purpose

Analyze Docker configuration: base images, privileges, capabilities, secrets
in images, and container isolation.

## Scope

- Included: Dockerfile practices, privileged mode, capabilities, secrets,
  resource limits, root user.
- Excluded: orchestration (`container-orchestration.md`).
- Layers: containers.

## Trigger Conditions

- Dockerfile/deployment changes.
- Claims of "hardened containers" to verify.

## Inputs

- Dockerfiles
- compose/k8s configs

## Investigation Method

1. Identify entry points: image builds/runs.
2. Identify trust boundaries: container → host.
3. Track relevant data: image contents.
4. Identify validation: minimality/privileges.
5. Identify security-sensitive operations: runtime privileges.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: escape surface.
10. Validate the finding: image/config review.

## Evidence Requirements

- E1: Dockerfile/config.
- E2: hardening gap.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on privileges.

## Safe Reproduction

- Local image review; dry-run builds.

## Root Cause

- Root users; privileged mode; unbounded resources.

## Impact

- Container escape, host compromise.

## Remediation

- Non-root; drop caps; read-only fs; resource limits; minimal images;
  image scanning.

## Regression Test

- Image config assertions (CI).

## Common False Positives

- Privileges required and scoped (verify).

## Related Skills

- `container-security.md`
- `image-security.md`
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

- Docker security best practices
- CIS Docker Benchmark
- CWE-250
