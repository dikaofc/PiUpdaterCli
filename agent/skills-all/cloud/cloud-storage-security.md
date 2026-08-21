# Skill: Cloud Storage Security

## Purpose

Analyze cloud storage security: bucket/object permissions, encryption,
public exposure, and access control.

## Scope

- Included: bucket policies/ACLs, public access, encryption, lifecycle,
  signed URLs.
- Excluded: general IAM (`cloud-iam-analysis.md`).
- Layers: cloud storage.

## Trigger Conditions

- Storage config changes.
- Claims of "private buckets" to verify.

## Inputs

- cloud configs
- infra-as-code

## Investigation Method

1. Identify entry points: storage access paths.
2. Identify trust boundaries: public vs private.
3. Track relevant data: object access.
4. Identify validation: policies/encryption.
5. Identify security-sensitive operations: data access.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: policy review.

## Evidence Requirements

- E1: storage configs.
- E2: exposure/encryption gap.

## Confidence

- CONFIRMED with E2.

## Severity

- HIGH for public sensitive data; MEDIUM otherwise.

## Safe Reproduction

- Local config review; dry-run permission checks.

## Root Cause

- Default-permissive buckets; missing encryption.

## Impact

- Data breach at scale.

## Remediation

- Private-by-default; least-privilege policies; encryption; signed URLs for
  access.

## Regression Test

- Policy assertions in CI.

## Common False Positives

- Intentional public assets (verify sensitivity).

## Related Skills

- `cloud-iam-analysis.md`
- `../database/backup-security.md`
- `../files/file-upload-security.md`

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

- Cloud provider storage security docs
- CWE-200
