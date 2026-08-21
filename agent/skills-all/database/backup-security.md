# Skill: Backup Security

## Purpose

Analyze backup security: encryption, access control, retention, and exposure
of database/config backups containing sensitive data.

## Scope

- Included: backup storage encryption, access control, public exposure,
  retention, restoration testing.
- Excluded: general data-at-rest encryption.
- Layers: ops/infra.

## Trigger Conditions

- Backup files in object storage/config.
- Claims of "encrypted backups" to verify.

## Inputs

- infra configs
- backup scripts
- tests

## Investigation Method

1. Identify entry points: backup pipelines.
2. Identify trust boundaries: backup access.
3. Track relevant data: backup contents.
4. Identify validation: encryption/access control.
5. Identify security-sensitive operations: data recovery.
6. Inspect authorization: backup access control.
7. Inspect error handling: N/A.
8. Inspect tests: restore tests.
9. Determine exploitability or correctness impact: exposure.
10. Validate the finding: inspect backup configs.

## Evidence Requirements

- E1: backup config/scripts.
- E2: exposure (unencrypted, public bucket, loose access).

## Confidence

- CONFIRMED with E2; MEDIUM with E1.

## Severity

- HIGH for exposed backups of sensitive data; MEDIUM otherwise.

## Safe Reproduction

- Local config review; restore dry-run in isolated storage.

## Root Cause

- Default storage permissions; unencrypted backups.

## Impact

- Mass data breach via backups, ransomware target.

## Remediation

- Encrypt backups; private storage with strict access; retention policy;
  tested restores.

## Regression Test

- Tests/checks asserting backup encryption and access control.

## Common False Positives

- Backups of non-sensitive data (still verify).

## Related Skills

- `../cloud/cloud-storage-security.md`
- `database-access-control.md`
- `../infrastructure/configuration-security.md`

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

- Cloud provider backup security docs
- CWE-200
