# Skill: Quota Bypass Analysis

## Purpose

Analyze quota and limit enforcement: whether usage quotas (uploads, credits,
API calls, storage) can be bypassed by identity manipulation, resets, or
parallel requests.

## Scope

- Included: quota identity, counting correctness, reset logic, parallel
  bypass, free-trial abuse.
- Excluded: rate limiting (`../api/api-rate-limiting.md`).
- Layers: business logic.

## Trigger Conditions

- Quota features (usage limits, trial caps).
- Claims of "quota enforced" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: quota-checked operations.
2. Identify trust boundaries: quota identity.
3. Track relevant data: usage accounting.
4. Identify validation: counting/reset correctness.
5. Identify security-sensitive operations: quota-gated actions.
6. Inspect authorization: quota identity spoofing.
7. Inspect error handling: N/A.
8. Inspect tests: quota edge tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: quota bypass tests.

## Evidence Requirements

- E1: quota code.
- E2: bypass path.
- E3: test demonstrating quota bypass.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on quota value.

## Safe Reproduction

- Local tests with parallel requests and identity manipulation.

## Root Cause

- Client-trusted quota identity; non-atomic counting; resettable quotas.

## Impact

- Free usage abuse, cost exposure, resource abuse.

## Remediation

- Server-side quota identity; atomic counting; conservative resets; monitor.

## Regression Test

- Tests asserting quota enforcement and bypass rejection.

## Common False Positives

- Quota enforcement verified working (edge cases covered).

## Related Skills

- `resource-limit-analysis.md`
- `../api/api-rate-limiting.md`
- `../performance/resource-exhaustion.md`

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

- OWASP API Security — Business Logic
- CWE-770
