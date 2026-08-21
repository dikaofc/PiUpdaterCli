# Skill: Diff Review

## Purpose

Review diffs: analyzing changes for security, correctness, and regression risk
in the context of the full codebase.

## Scope

- Included: diff analysis, context review, impact assessment.
- Excluded: full-file reviews (other review skills).
- Layers: any.

## Trigger Conditions

- PR/commit review.
- Post-fix verification.

## Inputs

- diffs
- repository context

## Investigation Method

1. Identify entry points: changed lines.
2. Identify trust boundaries: changed crossings.
3. Track relevant data: changed flows.
4. Identify validation: changed checks.
5. Identify security-sensitive operations: changed sinks.
6. Inspect authorization: changed checks.
7. Inspect error handling: N/A.
8. Inspect tests: changed coverage.
9. Determine exploitability or correctness impact: change effects.
10. Validate the finding: review surrounding code.

## Evidence Requirements

- E1: diff lines.
- E2+: context verification for findings.

## Confidence

- Per evidence.

## Severity

- Per impact.

## Safe Reproduction

- Local tests around changed behavior.

## Root Cause

- Per finding.

## Impact

- Catches issues before merge.

## Remediation

- Per finding.

## Regression Test

- Per finding.

## Common False Positives

- Changes judged without surrounding context.

## Related Skills

- `pull-request-review.md`
- `regression-risk-analysis.md`
- `security-code-review.md`

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

- Code review best practices
- OWASP Code Review Guide
