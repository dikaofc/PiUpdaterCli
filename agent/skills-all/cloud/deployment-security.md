# Skill: Deployment Security

## Purpose

Analyze deployment security: deployment credentials, approval gates,
rollback, and environment protection.

## Scope

- Included: deploy credentials, environment gates, rollback, prod access
  control.
- Excluded: CI configs (`ci-security.md`).
- Layers: deployment.

## Trigger Conditions

- Deployment changes.
- Claims of "protected deploys" to verify.

## Inputs

- deployment configs
- credential grants

## Investigation Method

1. Identify entry points: deploy paths.
2. Identify trust boundaries: CI → prod.
3. Track relevant data: deploy credentials.
4. Identify validation: gates/approvals.
5. Identify security-sensitive operations: prod changes.
6. Inspect authorization: deploy permissions.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: unauthorized deploy.
10. Validate the finding: config review.

## Evidence Requirements

- E1: deployment configs.
- E2: gate/permission gap.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for unauthorized deploy paths.

## Safe Reproduction

- Local config review.

## Root Cause

- Broad deploy credentials; no approvals.

## Impact

- Malicious deployment, prod tampering.

## Remediation

- Scoped deploy credentials; environment approvals; audit; rollback.

## Regression Test

- Config assertions.

## Common False Positives

- Gates enforced at platform (verify).

## Related Skills

- `pipeline-permission-analysis.md`
- `artifact-security.md`
- `../infrastructure/environment-analysis.md`

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

- CI/CD platform docs
- CWE-284
