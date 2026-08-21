# Skill: Regression Testing

## Purpose

Design regression tests: tests proving a bug is fixed and stays fixed, and
that normal behavior is preserved.

## Scope

- Included: test selection, design, integration into suites, CI.
- Excluded: specific test types (other testing skills).
- Layers: testing.

## Trigger Conditions

- Every confirmed bug (mandatory per operating model).
- Post-fix verification.

## Inputs

- bug/finding reports
- reproduction steps

## Investigation Method

1. Identify entry points: the bug's trigger path.
2. Identify trust boundaries: N/A.
3. Track relevant data: bug input → behavior.
4. Identify validation: the failing assertion.
5. Identify security-sensitive operations: affected behavior.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: existing coverage.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: test fails pre-fix, passes post-fix.

## Evidence Requirements

- E1: bug report/reproduction.
- E3: test demonstrating pre-fix failure and post-fix pass.

## Confidence

- CONFIRMED when the test fails pre-fix and passes post-fix.

## Severity

- N/A (testing artifact); quality gate for findings.

## Safe Reproduction

- Tests run locally/fixtures; assert both fix and normal behavior.

## Root Cause

- N/A.

## Impact

- Prevents recurrence.

## Remediation

- Add regression test per `../templates/regression-test.md`; run in CI.

## Regression Test

- The regression test itself, with: fails pre-fix, passes post-fix, adjacent
  behavior intact.

## Common False Positives

- Tests that pass pre-fix (not actually testing the bug).

## Related Skills

- `negative-testing.md`
- `boundary-testing.md`
- `reproduction-test-design.md`
- `../workflows/regression-review.md`

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

- Test documentation (xUnit/JUnit/pytest etc.)
- OWASP ASVS V14 (Testing)
