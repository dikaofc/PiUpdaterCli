# Skill: Pipeline Permission Analysis

## Purpose

Analyze pipeline permissions: CI tokens, deployment credentials, and
environment access — whether pipelines hold more privilege than needed.

## Scope

- Included: token scopes, environment approvals, credential grants, runner
  access.
- Excluded: workflow injection (`github-actions-security.md`).
- Layers: CI/CD.

## Trigger Conditions

- Pipeline changes.
- Claims of "least-privilege pipelines" to verify.

## Inputs

- CI configs
- infra credential grants

## Investigation Method

1. Identify entry points: pipeline steps.
2. Identify trust boundaries: CI → resources.
3. Track relevant data: credential scope.
4. Identify validation: least privilege.
5. Identify security-sensitive operations: deployments.
6. Inspect authorization: token permissions.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: over-grant.
10. Validate the finding: config review.

## Evidence Requirements

- E1: CI/config grants.
- E2: over-permission.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local config review.

## Root Cause

- Broad tokens; no environment gates.

## Impact

- CI compromise → production access.

## Remediation

- Least-privilege tokens; environment approvals; scoped credentials.

## Regression Test

- Config assertions.

## Common False Positives

- Grants scoped by conditions (verify).

## Related Skills

- `ci-security.md`
- `github-actions-security.md`
- `deployment-security.md`

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

- CI/CD platform security docs
- CWE-732
