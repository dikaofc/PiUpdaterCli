# Skill: Missing Test Analysis

## Purpose

Identify missing tests for security-critical code: untested validation,
authorization, error paths, and new behaviors.

## Scope

- Included: coverage gaps on security logic, negative-path gaps.
- Excluded: test design (../testing/*).
- Layers: review.

## Trigger Conditions

- Changes lacking tests.
- Coverage review.

## Inputs

- diffs
- coverage data

## Investigation Method

1. Identify entry points: changed logic.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: coverage of changed logic.
5. Identify security-sensitive operations: untested security logic.
6. Inspect authorization: untested checks.
7. Inspect error handling: untested paths.
8. Inspect tests: the subject.
9. Determine exploitability or correctness impact: risk.
10. Validate the finding: coverage check.

## Evidence Requirements

- E1: code + coverage evidence.

## Confidence

- HIGH with coverage data.

## Severity

- LOW–MEDIUM (test quality).

## Safe Reproduction

- Local coverage runs.

## Root Cause

- N/A.

## Impact

- Undetected regressions.

## Remediation

- Add tests for gaps.

## Regression Test

- New tests per gap.

## Common False Positives

- Coverage tools missing paths (verify).

## Related Skills

- `regression-risk-analysis.md`
- `../testing/negative-testing.md`
- `../testing/mutation-testing.md`

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

- Coverage tooling docs
