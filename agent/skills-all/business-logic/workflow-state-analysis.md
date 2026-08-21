# Skill: Workflow State Analysis

## Purpose

Analyze workflow state consistency: whether workflow steps keep consistent
state across stages, retries, and partial completions.

## Scope

- Included: step state storage, retry/cancel/refund semantics, partial
  completion, workflow replay.
- Excluded: transition validity (`state-transition-analysis.md`).
- Layers: business logic.

## Trigger Conditions

- Long-running workflows (orders, approvals, provisioning).
- Step state persisted across calls.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: workflow steps.
2. Identify trust boundaries: N/A.
3. Track relevant data: step state.
4. Identify validation: state consistency across steps.
5. Identify security-sensitive operations: workflow outcomes.
6. Inspect authorization: N/A.
7. Inspect error handling: partial-failure recovery.
8. Inspect tests: workflow edge tests.
9. Determine exploitability or correctness impact: inconsistency.
10. Validate the finding: workflow tests.

## Evidence Requirements

- E1: workflow code.
- E2: consistency gap.
- E3: test demonstrating inconsistent state.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on workflow value.

## Safe Reproduction

- Local workflow tests with retries/failures injected.

## Root Cause

- Non-atomic step updates; missing compensation.

## Impact

- Duplicate/partial completions, inconsistent outcomes.

## Remediation

- Idempotent steps; outbox/compensation; state snapshots.

## Regression Test

- Tests covering retry/cancel/partial-failure paths.

## Common False Positives

- Workflows with verified compensation (documented).

## Related Skills

- `state-transition-analysis.md`
- `duplicate-operation.md`
- `../database/transaction-integrity.md`

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
- CWE-698
