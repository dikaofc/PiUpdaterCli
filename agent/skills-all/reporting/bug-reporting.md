# Skill: Bug Reporting

## Purpose

Produce structured correctness-bug reports: expected vs actual behavior,
root cause, impact, and regression test.

## Scope

- Included: bug report structure, reproduction inclusion.
- Excluded: security reports (`security-reporting.md`).
- Layers: reporting.

## Trigger Conditions

- Confirmed non-security bugs.

## Inputs

- bug evidence

## Investigation Method

1. Identify entry points: the bug.
2. Identify trust boundaries: N/A.
3. Track relevant data: behavior.
4. Identify validation: expected behavior.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: reproduction.
9. Determine exploitability or correctness impact: impact.
10. Validate the finding: per `../templates/bug-report.md`.

## Evidence Requirements

- Included.

## Confidence

- Included.

## Severity

- Included.

## Safe Reproduction

- Reproduction steps.

## Root Cause

- Included.

## Impact

- Included.

## Remediation

- Included.

## Regression Test

- Included.

## Common False Positives

- Reporting intended behavior as a bug (verify spec).

## Related Skills

- `security-reporting.md`
- `../templates/bug-report.md`
- `finding-classification.md`

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

- `../references/bug-taxonomy.md`
