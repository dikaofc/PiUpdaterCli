# Skill: Replay Protection

## Purpose

Analyze replay protection: whether captured requests/tokens/operations can be
replayed to repeat effects or bypass controls (nonces, timestamps,
idempotency).

## Scope

- Included: replayed requests, token replay, nonce/timestamp validation,
  idempotency as replay control.
- Excluded: token single-use (`../session/token-replay.md`).
- Layers: API + business logic.

## Trigger Conditions

- State-changing requests without nonces.
- Replay-sensitive operations (payments, votes, claims).

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: replayable operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: request identity.
4. Identify validation: nonce/timestamp/idempotency.
5. Identify security-sensitive operations: repeated effects.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: replay tests.
9. Determine exploitability or correctness impact: replay effects.
10. Validate the finding: replay tests.

## Evidence Requirements

- E1: operation code.
- E2: missing replay control.
- E3: test demonstrating successful replay.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on the operation.

## Safe Reproduction

- Local tests replaying captured requests.

## Root Cause

- No nonces/idempotency; stateless operations without replay controls.

## Impact

- Repeated votes/claims/charges, control bypass.

## Remediation

- Nonces with one-time use; idempotency keys; signed timestamps where
  applicable.

## Regression Test

- Tests asserting replay rejection.

## Common False Positives

- Operations with inherent single-use semantics (verify).

## Related Skills

- `duplicate-operation.md`
- `../session/token-replay.md`
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

- OWASP API Security — Business Logic
- CWE-294
