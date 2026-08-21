# Skill: Security Reporting

## Purpose

Produce structured security reports: findings with severity, confidence,
evidence, root cause, impact, remediation, and regression tests.

## Scope

- Included: report structure, prioritization, language.
- Excluded: bug reports (`bug-reporting.md`).
- Layers: reporting.

## Trigger Conditions

- Audit completion.

## Inputs

- findings
- evidence

## Investigation Method

1. Identify entry points: findings list.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: completeness.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: per `../templates/vulnerability-report.md`.

## Evidence Requirements

- Included per finding.

## Confidence

- Included per finding.

## Severity

- Included per finding.

## Safe Reproduction

- N/A.

## Root Cause

- Included.

## Impact

- Included.

## Remediation

- Included.

## Regression Test

- Included.

## Common False Positives

- Over-reporting speculative findings.

## Related Skills

- `executive-summary.md`
- `finding-classification.md`
- `../templates/audit-summary.md`
- `../METHODOLOGY.md` (AI Response Rules)

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

- OWASP Testing Guide reporting
