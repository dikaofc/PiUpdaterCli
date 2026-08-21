# Skill: Regression Risk Analysis

## Purpose

Assess regression risk of changes: which existing behaviors could break, and
whether tests cover them.

## Scope

- Included: behavior dependencies, shared code impact, test coverage
  assessment.
- Excluded: full testing (`../testing/*`).
- Layers: change analysis.

## Trigger Conditions

- Any change to shared/security-sensitive code.
- Post-fix review.

## Inputs

- diffs
- tests

## Investigation Method

1. Identify entry points: changed functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: callers.
4. Identify validation: affected behaviors.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: coverage of affected behaviors.
9. Determine exploitability or correctness impact: risk.
10. Validate the finding: run affected tests.

## Evidence Requirements

- E1: change + callers.
- E3: test results.

## Confidence

- Per evidence.

## Severity

- Per risk.

## Safe Reproduction

- Local affected-test runs.

## Root Cause

- N/A.

## Impact

- Prevents regressions.

## Remediation

- Add/adjust tests for affected behaviors.

## Regression Test

- Affected-behavior tests.

## Common False Positives

- Assuming callers unaffected without checking.

## Related Skills

- `missing-test-analysis.md`
- `diff-review.md`
- `../testing/regression-testing.md`

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

- Code review references
