# Skill: Pull Request Review

## Purpose

Review pull requests: changes assessed for security, correctness,
maintainability, and test coverage before merge.

## Scope

- Included: PR context, diff review, tests, blocking criteria.
- Excluded: line-level detail (diff-review.md).
- Layers: any.

## Trigger Conditions

- Every PR (per project policy).
- Security-sensitive changes.

## Inputs

- PR diff/description
- CI results

## Investigation Method

1. Identify entry points: changed code.
2. Identify trust boundaries: changed crossings.
3. Track relevant data: changed flows.
4. Identify validation: checks.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: checks.
7. Inspect error handling: N/A.
8. Inspect tests: added coverage.
9. Determine exploitability or correctness impact: findings.
10. Validate the finding: context + tests.

## Evidence Requirements

- E1+ with context verification.

## Confidence

- Per evidence.

## Severity

- Per impact.

## Safe Reproduction

- Local tests.

## Root Cause

- Per finding.

## Impact

- Merge-time quality gate.

## Remediation

- Per finding.

## Regression Test

- Per finding.

## Common False Positives

- Judging without running context.

## Related Skills

- `diff-review.md`
- `missing-test-analysis.md`
- `dangerous-change-analysis.md`

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

- PR review best practices
- OWASP Code Review Guide
