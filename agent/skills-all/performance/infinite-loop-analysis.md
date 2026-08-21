# Skill: Infinite Loop Analysis

## Purpose

Detect infinite loops and hangs: unbounded while loops, recursion without
termination, and blocking waits driven by input.

## Scope

- Included: loop termination conditions, recursion depth, blocking waits.
- Excluded: algorithmic cost (`algorithmic-complexity.md`).
- Layers: runtime.

## Trigger Conditions

- User-influenced loop conditions.
- Recursion without depth limits.
- Claims of "terminates" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: loops/recursion.
2. Identify trust boundaries: input → loop.
3. Track relevant data: loop state.
4. Identify validation: termination conditions.
5. Identify security-sensitive operations: N/A (availability).
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: termination tests.
9. Determine exploitability or correctness impact: hang.
10. Validate the finding: timeout-guarded tests.

## Evidence Requirements

- E1: loop/recursion code.
- E2: unbounded condition.
- E3: test demonstrating non-termination (with test timeout).

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local tests with timeouts.

## Root Cause

- Input-driven loop bounds; missing base cases.

## Impact

- Hangs, request starvation, DoS.

## Remediation

- Bounded loops; depth limits; timeouts; iteration caps.

## Regression Test

- Termination tests with worst-case inputs.

## Common False Positives

- Loops bounded by fixed data (verify).

## Related Skills

- `cpu-exhaustion.md`
- `algorithmic-complexity.md`
- `../errors/timeout-analysis.md`

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

- CWE-835 / CWE-834
