# Skill: Crash Triage

## Purpose

Triage fuzz findings: deduplicate, minimize, classify (real bug vs harness
artifact), and convert into actionable findings with reproducers.

## Scope

- Included: minimization, dedup, classification, regression conversion.
- Excluded: harness design (`fuzz-harness-design.md`).
- Layers: testing.

## Trigger Conditions

- Fuzz campaigns with crashes.
- Claims of "no crashes" to verify.

## Inputs

- fuzz outputs
- target code

## Investigation Method

1. Identify entry points: crash reproducers.
2. Identify trust boundaries: N/A.
3. Track relevant data: crash input.
4. Identify validation: minimization.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: severity.
10. Validate the finding: reproduce on the real target.

## Evidence Requirements

- E1: crash artifacts.
- E3: minimized reproducer on the real target.

## Confidence

- CONFIRMED with reproducible minimized input.

## Severity

- Per impact after triage.

## Safe Reproduction

- Local sandboxed reproduction.

## Root Cause

- Identify the defective code from the minimized input.

## Impact

- Converts fuzz noise into findings.

## Remediation

- Fix root cause; add reproducer as regression test.

## Regression Test

- Minimized crash input as regression test.

## Common False Positives

- Harness-caused crashes (verify against real entry path).

## Related Skills

- `fuzzing-strategy.md`
- `crash-triage.md` (peer)
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

- Fuzzing triage guidance
- CWE-20
