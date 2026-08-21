# Skill: Reproduction Test Design

## Purpose

Design minimal reproductions: converting a bug report or suspicion into the
smallest deterministic test demonstrating the behavior.

## Scope

- Included: reproduction minimization, determinism, fixture design.
- Excluded: regression placement (`regression-testing.md`).
- Layers: testing.

## Trigger Conditions

- New findings needing proof.
- Incident debugging.

## Inputs

- bug reports
- hypotheses

## Investigation Method

1. Identify entry points: trigger path.
2. Identify trust boundaries: N/A.
3. Track relevant data: minimal input.
4. Identify validation: the failing assertion.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: existing.
9. Determine exploitability or correctness impact: N/A.
10. Validate the finding: reproduction runs.

## Evidence Requirements

- E1: bug/hypothesis.
- E3: minimal deterministic reproduction.

## Confidence

- CONFIRMED with a running reproduction.

## Severity

- N/A.

## Safe Reproduction

- Local fixtures/mocks; no external targets.

## Root Cause

- N/A (reproduction supports root-cause work).

## Impact

- Proof for findings; basis for regression tests.

## Remediation

- Document reproduction steps; convert to regression test on fix.

## Regression Test

- The reproduction as the regression test.

## Common False Positives

- Reproductions with environment-dependent flakiness (fix determinism).

## Related Skills

- `regression-testing.md`
- `../dynamic-analysis/dynamic-behavior-analysis.md`
- `../workflows/incident-debugging.md`

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

- Testing references
- OWASP ASVS V14
