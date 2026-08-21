# Skill: Maintainability Analysis

## Purpose

Assess maintainability: complexity, duplication, dead code, and testability of
security-sensitive code.

## Scope

- Included: complexity, duplication, clarity, testability.
- Excluded: functional review (other skills).
- Layers: review.

## Trigger Conditions

- Security-critical complex code.
- Refactor planning.

## Inputs

- source code

## Investigation Method

1. Identify entry points: complex functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: complexity metrics.
5. Identify security-sensitive operations: complex security logic.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: testability.
9. Determine exploitability or correctness impact: risk.
10. Validate the finding: metric review.

## Evidence Requirements

- E1: code evidence.

## Confidence

- HIGH with metrics.

## Severity

- INFORMATIONAL typically.

## Safe Reproduction

- N/A.

## Root Cause

- N/A.

## Impact

- Bug-prone code.

## Remediation

- Refactor high-risk complexity; add tests.

## Regression Test

- Tests after refactor.

## Common False Positives

- Complexity without risk (verify reachability).

## Related Skills

- `security-code-review.md`
- `dead-code-analysis.md`
- `missing-test-analysis.md`

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

- Code metrics references
