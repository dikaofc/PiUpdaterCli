# Skill: Filesystem Permissions

## Purpose

Analyze filesystem permissions: world-writable files/dirs, exposed sensitive
files, temp file safety, and symlink attacks.

## Scope

- Included: permissions on configs/secrets/data, temp dirs, symlink handling.
- Excluded: process privileges (`process-permissions.md`).
- Layers: OS/filesystem.

## Trigger Conditions

- World-writable paths.
- Claims of "secure permissions" to verify.

## Inputs

- code (file operations)
- OS/container configs

## Investigation Method

1. Identify entry points: file paths used.
2. Identify trust boundaries: local users.
3. Track relevant data: file creation/use.
4. Identify validation: permission settings.
5. Identify security-sensitive operations: sensitive files.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: tamper/read.
10. Validate the finding: inspect permissions.

## Evidence Requirements

- E1: file path/permission code.
- E2: insecure permissions.

## Confidence

- CONFIRMED with E2.

## Severity

- MEDIUM–HIGH depending on file sensitivity.

## Safe Reproduction

- Local inspection of auditor-controlled paths.

## Root Cause

- Default permissions; predictable temp paths.

## Impact

- Config/secret tampering, data modification.

## Remediation

- Least-privilege permissions; secure temp dirs (mktemp); symlink-safe
  opens.

## Regression Test

- Tests asserting permissions on created files.

## Common False Positives

- Permissions tightened by umask (verify).

## Related Skills

- `process-permissions.md`
- `../concurrency/toctou-analysis.md`
- `../files/path-traversal.md`

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

- OS security docs
- CWE-732 / CWE-377
