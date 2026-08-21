# Skill: Cloud IAM Analysis

## Purpose

Analyze cloud IAM: roles, permissions, trust policies, service accounts, and
least-privilege access to cloud resources.

## Scope

- Included: role definitions, policy grants, trust relationships, service
  accounts, key access.
- Excluded: storage-specific (`cloud-storage-security.md`).
- Layers: cloud.

## Trigger Conditions

- Cloud config changes.
- Claims of "least privilege" to verify.

## Inputs

- cloud policies (IAM templates)
- infra-as-code

## Investigation Method

1. Identify entry points: resource access.
2. Identify trust boundaries: principals.
3. Track relevant data: permission grants.
4. Identify validation: least privilege.
5. Identify security-sensitive operations: resource access.
6. Inspect authorization: policy correctness.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: over-permission.
10. Validate the finding: policy review.

## Evidence Requirements

- E1: IAM configs.
- E2: over-permission.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on scope.

## Safe Reproduction

- Local policy review; dry-run IAM analysis tools.

## Root Cause

- Broad wildcard grants; default service accounts.

## Impact

- Lateral movement, data access at scale.

## Remediation

- Least-privilege roles; scoped trust; key rotation; audit.

## Regression Test

- Policy assertions in CI.

## Common False Positives

- Roles scoped by conditions (verify).

## Related Skills

- `cloud-storage-security.md`
- `../containers/container-orchestration.md`
- `cloud-secret-analysis.md`

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

- Cloud provider IAM docs
- CWE-732
