# Skill: Retry Analysis

## Purpose

Analyze retry behavior: unbounded retries, retry storms, duplicate effects on
retry, and retry amplification of failures.

## Scope

- Included: retry counts/backoff, idempotent retries, retry storms,
  amplification.
- Excluded: timeouts (`timeout-analysis.md`).
- Layers: resilience.

## Trigger Conditions

- Retry loops in code/clients.
- Claims of "bounded retries" to verify.

## Inputs

- source code
- configs
- tests

## Investigation Method

1. Identify entry points: retrying operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: retry counts.
4. Identify validation: bounds/backoff.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: N/A.
7. Inspect error handling: retry-on-what errors.
8. Inspect tests: retry behavior tests.
9. Determine exploitability or correctness impact: amplification.
10. Validate the finding: retry tests.

## Evidence Requirements

- E1: retry code.
- E2: unbounded/unsafe retry.
- E3: test demonstrating amplification/duplicate effects.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH (availability/cost).

## Safe Reproduction

- Local tests with failing mocks; assert bounded retries.

## Root Cause

- Missing bounds/backoff; retrying non-idempotent operations.

## Impact

- Retry storms, duplicate charges, cost explosion.

## Remediation

- Bounded retries with exponential backoff + jitter; retry only idempotent
  ops; circuit breakers.

## Regression Test

- Tests asserting retry bounds and idempotency.

## Common False Positives

- Clients with single attempts (verify).

## Related Skills

- `timeout-analysis.md`
- `../business-logic/duplicate-operation.md`
- `../api/api-idempotency.md`

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

- Resilience patterns (Retry/Backoff) — Azure/AWS docs
- CWE-799
