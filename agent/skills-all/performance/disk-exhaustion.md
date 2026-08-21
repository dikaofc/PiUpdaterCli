# Skill: Disk Exhaustion

## Purpose

Analyze disk exhaustion: unbounded file writes, log growth, temp file leaks,
and upload accumulation filling disk.

## Scope

- Included: write drivers, log growth, temp cleanup, upload storage.
- Excluded: CPU/memory (other skills).
- Layers: runtime/storage.

## Trigger Conditions

- User-driven file creation.
- Unbounded logging.

## Inputs

- source code
- storage configs

## Investigation Method

1. Identify entry points: write paths.
2. Identify trust boundaries: input → storage.
3. Track relevant data: write volume.
4. Identify validation: size limits/cleanup.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: cleanup.
8. Inspect tests: growth tests.
9. Determine exploitability or correctness impact: fill.
10. Validate the finding: local growth tests.

## Evidence Requirements

- E1: write code.
- E2: unbounded growth.
- E3: test demonstrating unbounded disk use.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local tests with bounded temp storage.

## Root Cause

- No size limits; missing cleanup; unbounded logs.

## Impact

- Disk full, service outage, data loss.

## Remediation

- Size limits; cleanup; log rotation; storage quotas.

## Regression Test

- Tests asserting bounded disk use.

## Common False Positives

- External storage with quotas (verify).

## Related Skills

- `resource-exhaustion.md`
- `../files/file-upload-security.md`
- `../observability/logging-security.md`

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

- OWASP DoS guidance
- CWE-400
