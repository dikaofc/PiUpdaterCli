# Skill: Queue Security

## Purpose

Analyze queue security: message authentication, validation, authorization on
consume, and poison-message handling.

## Scope

- Included: message trust, schema validation, per-message authz, poison
  handling, queue access control.
- Excluded: worker logic (`worker-security.md`).
- Layers: messaging.

## Trigger Conditions

- Queue consumers.
- Claims of "trusted messages" to verify.

## Inputs

- source code (producers/consumers)
- queue configs

## Investigation Method

1. Identify entry points: producers/consumers.
2. Identify trust boundaries: producer → consumer.
3. Track relevant data: message content.
4. Identify validation: message validation/authn.
5. Identify security-sensitive operations: consumer actions.
6. Inspect authorization: per-message authz.
7. Inspect error handling: poison messages.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: injection.
10. Validate the finding: consumer tests.

## Evidence Requirements

- E1: queue code.
- E2: validation/authz gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local queue fixtures with crafted messages.

## Root Cause

- Trusting queue contents; no message authz.

## Impact

- Injection, unauthorized actions via messages.

## Remediation

- Validate messages; authenticate producers; re-authorize on consume;
  poison-message handling.

## Regression Test

- Consumer tests with hostile messages.

## Common False Positives

- Internally trusted queues with verified producers.

## Related Skills

- `worker-security.md`
- `background-job-security.md`
- `../input-validation/schema-validation.md`

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

- Message broker security docs
- CWE-345
