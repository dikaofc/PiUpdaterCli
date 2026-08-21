# Skill: State Transition Analysis

## Purpose

Analyze state machines (orders, approvals, tickets, accounts): valid
transitions, invalid/skipped/reversed transitions, and duplicate transitions.

## Scope

- Included: state definitions, transition guards, re-entry, skip/reverse,
  concurrent transitions.
- Excluded: auth-state machines (`../authentication/login-state-machine.md`).
- Layers: business logic.

## Trigger Conditions

- Status fields updated by clients.
- Multi-step workflows.
- Claims of "validated transitions" to verify.

## Inputs

- source code
- state definitions
- tests

## Investigation Method

1. Identify entry points: state-changing operations.
2. Identify trust boundaries: N/A.
3. Track relevant data: state transitions.
4. Identify validation: transition guards.
5. Identify security-sensitive operations: workflow steps.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: transition tests.
9. Determine exploitability or correctness impact: invalid transitions.
10. Validate the finding: transition-matrix tests.

## Evidence Requirements

- E1: transition code.
- E2: missing guard.
- E3: test demonstrating an invalid transition.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- MEDIUM–HIGH depending on workflow value.

## Safe Reproduction

- Local transition-matrix tests.

## Root Cause

- Client-set status; no transition validation; race between transitions.

## Impact

- Workflow bypass, financial abuse, state corruption.

## Remediation

- Server-side state machines with guard functions; atomic transitions;
  transition logging.

## Regression Test

- Transition-matrix tests asserting only valid transitions succeed.

## Common False Positives

- Transitions guarded in shared services (verify).

## Related Skills

- `workflow-state-analysis.md`
- `authorization-workflow.md`
- `../concurrency/race-condition.md`

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
- CWE-841
