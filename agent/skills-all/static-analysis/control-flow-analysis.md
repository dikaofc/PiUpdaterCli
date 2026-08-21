# Skill: Control Flow Analysis

## Purpose

Analyze control flow: branches, loops, error paths, and reachability to find
unreachable or mis-ordered logic and missed error handling.

## Scope

- Included: branch coverage, loop behavior, early returns, error paths.
- Excluded: data flow (`data-flow-analysis.md`).
- Layers: source.

## Trigger Conditions

- Complex branching logic.
- Error-path audits.

## Inputs

- source code

## Investigation Method

1. Identify entry points: functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: branch paths.
4. Identify validation: branch coverage.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: checks in all branches.
7. Inspect error handling: all error paths.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: path tests.

## Evidence Requirements

- E1: control-flow code.
- E2: gap path.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM typically.

## Safe Reproduction

- Local path tests.

## Root Cause

- N/A (identifies flows).

## Impact

- Missed branches hide bugs.

## Remediation

- Per finding.

## Regression Test

- Path tests.

## Common False Positives

- Paths proven unreachable (verify).

## Related Skills

- `static-code-analysis.md`
- `data-flow-analysis.md`
- `../errors/exception-analysis.md`

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

- Software analysis references
- CWE
