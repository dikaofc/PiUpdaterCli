# Skill: Database Error Leakage

## Purpose

Analyze database error handling: whether DB errors, schemas, SQL, or data leak
to clients through error messages, and whether errors aid enumeration.

## Scope

- Included: raw DB exceptions to clients, schema/SQL in errors, distinct
  errors enabling enumeration.
- Excluded: general error handling (`../errors/*`).
- Layers: data access → responses.

## Trigger Conditions

- Raw DB errors surfaced.
- Distinct errors per data state.
- Claims of "no leakage" to verify.

## Inputs

- source code (error handling)
- tests

## Investigation Method

1. Identify entry points: DB-calling handlers.
2. Identify trust boundaries: store → client.
3. Track relevant data: exception → response.
4. Identify validation: generic error mapping.
5. Identify security-sensitive operations: data access.
6. Inspect authorization: N/A.
7. Inspect error handling: the subject.
8. Inspect tests: error-path tests.
9. Determine exploitability or correctness impact: leakage.
10. Validate the finding: trigger DB errors locally.

## Evidence Requirements

- E1: error mapping code.
- E3: test showing DB details in responses.

## Confidence

- CONFIRMED with E3; HIGH with E1.

## Severity

- MEDIUM (schema/data leakage, enumeration); LOW for benign details.

## Safe Reproduction

- Local tests forcing DB errors (bad input, missing rows) and inspecting
  responses.

## Root Cause

- Returning raw exceptions; permissive error middleware.

## Impact

- Reconnaissance, enumeration, targeted injection.

## Remediation

- Map DB errors to generic messages; log full details server-side.

## Regression Test

- Error-path tests asserting generic responses.

## Common False Positives

- Errors sanitized by framework middleware (verify).

## Related Skills

- `../errors/stack-trace-exposure.md`
- `../errors/sensitive-error-data.md`
- `../api/api-error-handling.md`

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

- OWASP Error Handling Cheat Sheet
- CWE-209
