# Skill: Atomicity Analysis

## Purpose

Analyze atomicity: whether multi-step operations are atomic (all-or-nothing)
under concurrency and failure, and whether atomic primitives are used
correctly (CAS, increments, transactions).

## Scope

- Included: atomic primitives usage, check-then-act atomicity, transaction
  atomicity, counter correctness.
- Excluded: rollback semantics (`../database/transaction-integrity.md`).
- Layers: application + data.

## Trigger Conditions

- Counters/increment patterns.
- Read-modify-write sequences.
- Claims of "atomic" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: state-changing operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: state mutations.
4. Identify validation: atomic primitives/transactions.
5. Identify security-sensitive operations: state changes.
6. Inspect authorization: N/A.
7. Inspect error handling: partial states.
8. Inspect tests: concurrency tests.
9. Determine exploitability or correctness impact: lost updates.
10. Validate the finding: concurrent tests.

## Evidence Requirements

- E1: mutation code.
- E2: non-atomic sequence.
- E3: test demonstrating lost update/partial effect.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on state.

## Safe Reproduction

- Local parallel tests with counters/state.

## Root Cause

- Non-atomic increments; read-modify-write without CAS/locks.

## Impact

- Lost updates, incorrect counters/balances.

## Remediation

- Atomic increments (INCR/`fetch_add`), CAS loops, transactions.

## Regression Test

- Parallel tests asserting exact final state.

## Common False Positives

- Single-writer flows (verify).

## Related Skills

- `race-condition.md`
- `../database/race-condition-database.md`
- `lock-analysis.md`

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

- Atomicity docs (per language/store)
- CWE-362
