# Skill: Call Graph Analysis

## Purpose

Analyze call graphs: reachability of functions from entry points, dependency
usage, and impact of changes — verifying whether code is truly reachable.

## Scope

- Included: call-chain reachability, dependency usage, change impact.
- Excluded: data values (`data-flow-analysis.md`).
- Layers: source.

## Trigger Conditions

- Dependency reachability questions.
- Impact analysis of changes.

## Inputs

- source code
- dependency trees

## Investigation Method

1. Identify entry points: entry functions.
2. Identify trust boundaries: N/A.
3. Track relevant data: call chains.
4. Identify validation: reachability.
5. Identify security-sensitive operations: sinks.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: reachable code.
10. Validate the finding: verify chain with references.

## Evidence Requirements

- E1: call chain evidence.
- E2: verified reachable path.

## Confidence

- HIGH with E2.

## Severity

- N/A (feeds other findings).

## Safe Reproduction

- Static graph analysis.

## Root Cause

- N/A.

## Impact

- Prevents false positives on unreachable code.

## Remediation

- N/A.

## Regression Test

- N/A.

## Common False Positives

- Dynamic dispatch hiding callers (reflection, DI) — check.

## Related Skills

- `dead-code-analysis.md`
- `taint-analysis.md`
- `../dependencies/transitive-dependencies.md`

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

- Static analysis tools (per language)
- CWE
