# Skill: Worker Security

## Purpose

Analyze worker security: workers consuming untrusted input (files, messages,
webhooks), their validation, and privileged operations.

## Scope

- Included: worker inputs, validation, privilege use, resource bounds.
- Excluded: queue transport (`queue-security.md`).
- Layers: background processing.

## Trigger Conditions

- Worker processes.
- Workers with privileged access.

## Inputs

- source code (workers)

## Investigation Method

1. Identify entry points: worker entry functions.
2. Identify trust boundaries: input → worker.
3. Track relevant data: worker inputs.
4. Identify validation: input validation.
5. Identify security-sensitive operations: privileged actions.
6. Inspect authorization: per-input authz.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: abuse.
10. Validate the finding: worker tests.

## Evidence Requirements

- E1: worker code.
- E2: validation gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- MEDIUM–HIGH.

## Safe Reproduction

- Local worker tests with crafted inputs.

## Root Cause

- Trusting worker inputs; broad privileges.

## Impact

- Injection, unauthorized actions.

## Remediation

- Validate inputs; least-privilege workers; re-authorize.

## Regression Test

- Worker input tests.

## Common False Positives

- Workers with validated, trusted inputs (verify).

## Related Skills

- `queue-security.md`
- `background-job-security.md`
- `../files/parser-security.md`

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

- OWASP ASVS V1
- CWE-345
