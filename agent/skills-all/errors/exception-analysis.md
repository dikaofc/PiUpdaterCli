# Skill: Exception Analysis

## Purpose

Analyze exception handling: unhandled exceptions, swallowed errors, wrong
exception types, and error paths that corrupt state or skip controls.

## Scope

- Included: catch coverage, swallowed exceptions, error-path state, exception
  in critical paths.
- Excluded: leakage (`stack-trace-exposure.md`).
- Layers: all error paths.

## Trigger Conditions

- Bare/empty catch blocks.
- Error paths in state-changing code.
- Claims of "handled errors" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: error-prone operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: failure behavior.
4. Identify validation: catch coverage.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: checks on error paths.
7. Inspect error handling: the subject.
8. Inspect tests: exception-injection tests.
9. Determine exploitability or correctness impact: failure behavior.
10. Validate the finding: exception-injection tests.

## Evidence Requirements

- E1: catch/throw code.
- E2: gap (swallowed/unhandled).
- E3: test demonstrating incorrect failure behavior.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM (correctness/availability); HIGH if state corruption.

## Safe Reproduction

- Local tests injecting exceptions at each path.

## Root Cause

- Swallowing exceptions; missing error paths; wrong types.

## Impact

- Silent failures, state corruption, partial operations.

## Remediation

- Handle exceptions at appropriate boundaries; log and fail safe; no empty
  catches.

## Regression Test

- Exception-injection tests per error path.

## Common False Positives

- Deliberately ignored non-critical errors (verify impact).

## Related Skills

- `error-boundary-analysis.md`
- `fallback-security.md`
- `../database/transaction-integrity.md`

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

- OWASP Error Handling Cheat Sheet
- CWE-390 / CWE-703
