# Skill: Background Job Security

## Purpose

Analyze background job security: job parameters, authorization re-checks,
sensitive data in jobs, and job abuse.

## Scope

- Included: job arguments, authz at execution, data handling, retries.
- Excluded: queue transport (`queue-security.md`).
- Layers: background processing.

## Trigger Conditions

- Background job systems (Sidekiq, Celery, etc.).
- Jobs performing privileged actions.

## Inputs

- source code (jobs)

## Investigation Method

1. Identify entry points: job definitions.
2. Identify trust boundaries: enqueuer → job.
3. Track relevant data: job arguments.
4. Identify validation: argument validation.
5. Identify security-sensitive operations: job actions.
6. Inspect authorization: re-check at execution.
7. Inspect error handling: retries.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: job abuse.
10. Validate the finding: job tests.

## Evidence Requirements

- E1: job code.
- E2: validation/authz gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local job tests with crafted arguments.

## Root Cause

- Jobs trust enqueuer; no re-authorization; sensitive args.

## Impact

- Unauthorized privileged actions via enqueue.

## Remediation

- Validate args; re-authorize in jobs; avoid sensitive data in job payloads.

## Regression Test

- Job tests with hostile arguments.

## Common False Positives

- Jobs with verified enqueue-side checks.

## Related Skills

- `worker-security.md`
- `queue-security.md`
- `../authorization/server-side-authorization.md`

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

- Background-job framework docs
- CWE-345
