# Skill: Process Permissions

## Purpose

Analyze process permissions: running as root, excessive capabilities, file
ownership, and privilege separation.

## Scope

- Included: user/capabilities, setuid, privilege drops, container caps.
- Excluded: filesystem permissions (`filesystem-permissions.md`).
- Layers: OS/container.

## Trigger Conditions

- Services running as root.
- Setuid binaries; broad capabilities.

## Inputs

- Dockerfiles/systemd/process configs
- code (privilege handling)

## Investigation Method

1. Identify entry points: process starts.
2. Identify trust boundaries: process → OS.
3. Track relevant data: N/A.
4. Identify validation: least privilege.
5. Identify security-sensitive operations: privileged ops.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: escalation.
10. Validate the finding: inspect process configs.

## Evidence Requirements

- E1: process configs/code.
- E2: excessive privilege.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on exposure.

## Safe Reproduction

- Local process config review.

## Root Cause

- Default root; no capability reduction.

## Impact

- Post-exploit escalation, container escape.

## Remediation

- Non-root user; drop capabilities; seccomp/AppArmor.

## Regression Test

- Config assertions on process user/caps.

## Common False Positives

- Privileges dropped in code after start (verify).

## Related Skills

- `../containers/docker-security.md`
- `filesystem-permissions.md`
- `../languages/shell.md`

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

- Docker/OS security docs
- CWE-250 / CWE-269
