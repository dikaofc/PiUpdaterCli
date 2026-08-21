# Skill: Authorization Workflow

## Purpose

Analyze approval/authorization workflows (approvals, sign-offs, escalation):
approver identity, bypass paths, self-approval, and audit trails.

## Scope

- Included: approver validation, self-approval prevention, escalation,
  approval state, audit logging.
- Excluded: role model (`../authorization/role-analysis.md`).
- Layers: business logic.

## Trigger Conditions

- Approval workflows (purchases, access grants, content).
- Claims of "requires approval" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: approval steps.
2. Identify trust boundaries: requester vs approver.
3. Track relevant data: approval decisions.
4. Identify validation: approver eligibility; no self-approval.
5. Identify security-sensitive operations: grants.
6. Inspect authorization: approval authority.
7. Inspect error handling: N/A.
8. Inspect tests: approval bypass tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: approval-path tests.

## Evidence Requirements

- E1: approval code.
- E2: bypass path (self-approval, wrong approver).
- E3: test demonstrating unauthorized approval.

## Confidence

- CONFIRMED with E3; HIGH with E2; MEDIUM with E1.

## Severity

- HIGH for high-value approvals.

## Safe Reproduction

- Local tests with requester/approver roles.

## Root Cause

- Approver checks missing; client-trusted approver id.

## Impact

- Unauthorized grants, financial abuse.

## Remediation

- Server-side approver validation; no self-approval; audit logs; separation
  of duties.

## Regression Test

- Tests asserting approval authority and no self-approval.

## Common False Positives

- Approval enforced by workflow engine (verify rules).

## Related Skills

- `state-transition-analysis.md`
- `workflow-state-analysis.md`
- `../authorization/access-control-analysis.md`
- `../observability/audit-trail-analysis.md`

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
