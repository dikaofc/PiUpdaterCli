# Skill: Alerting Correctness

## Purpose

Analyze alerting correctness: rules that detect the right events, avoid noise,
and produce actionable alerts.

## Scope

- Included: rule accuracy, thresholds, noise, escalation.
- Excluded: coverage (`monitoring-coverage.md`).
- Layers: observability.

## Trigger Conditions

- Alert review.
- Claims of "alerting works" to verify.

## Inputs

- alert rules
- alert history

## Investigation Method

1. Identify entry points: rules.
2. Identify trust boundaries: N/A.
3. Track relevant data: N/A.
4. Identify validation: rule accuracy.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: N/A.
9. Determine exploitability or correctness impact: missed alerts.
10. Validate the finding: rule review.

## Evidence Requirements

- E1: rules.
- E2: gap/noise.

## Confidence

- CONFIRMED with E2.

## Severity

- LOW–MEDIUM.

## Safe Reproduction

- N/A.

## Root Cause

- Misconfigured rules.

## Impact

- Missed incidents, alert fatigue.

## Remediation

- Rule tuning; validation tests; escalation.

## Regression Test

- N/A.

## Common False Positives

- Alerts handled out-of-band (verify).

## Related Skills

- `monitoring-coverage.md`
- `../authentication/credential-stuffing-defense.md`

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

- Monitoring/alerting docs
