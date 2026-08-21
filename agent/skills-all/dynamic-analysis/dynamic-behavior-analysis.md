# Skill: Dynamic Behavior Analysis

## Purpose

Analyze runtime behavior: running the system locally to observe, confirm, or
refute suspected behaviors (E3 evidence).

## Scope

- Included: controlled runs, request/response observation, state inspection.
- Excluded: instrumentation specifics (`runtime-instrumentation.md`).
- Layers: runtime.

## Trigger Conditions

- Validating any finding candidate.
- Incident debugging.

## Inputs

- running system (local)
- test inputs

## Investigation Method

1. Identify entry points: trigger paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: behavior.
4. Identify validation: expected vs actual.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: behavior on denial.
7. Inspect error handling: error behavior.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: observed impact.
10. Validate the finding: repeat runs.

## Evidence Requirements

- E3: observed behavior with artifacts.
- E4: observed impact.

## Confidence

- HIGH+ with E3/E4.

## Severity

- Per observed impact.

## Safe Reproduction

- Local sandboxed runs only.

## Root Cause

- Supports root-cause validation.

## Impact

- Confirms/refutes findings.

## Remediation

- Per finding.

## Regression Test

- Convert observations to tests.

## Common False Positives

- Environment-specific behavior (state the environment).

## Related Skills

- `runtime-instrumentation.md`
- `../testing/reproduction-test-design.md`
- `../context/runtime-model.md`

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

- Runtime testing references
- OWASP ASVS V14
