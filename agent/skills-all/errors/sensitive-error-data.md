# Skill: Sensitive Error Data

## Purpose

Analyze whether error responses/logs contain sensitive data: tokens, keys,
PII, internal URLs, query details, or user data.

## Scope

- Included: exception payloads, log lines, error responses with sensitive
  values.
- Excluded: stack traces specifically (`stack-trace-exposure.md`).
- Layers: error paths + logging.

## Trigger Conditions

- Errors including request data/headers.
- Claims of "redacted errors" to verify.

## Inputs

- source code
- tests

## Investigation Method

1. Identify entry points: error-producing paths.
2. Identify trust boundaries: N/A.
3. Track relevant data: sensitive values in errors.
4. Identify validation: redaction.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: the subject.
8. Inspect tests: error-content tests.
9. Determine exploitability or correctness impact: leakage.
10. Validate the finding: trigger errors and inspect content.

## Evidence Requirements

- E1: error construction code.
- E3: test showing sensitive values in errors/logs.

## Confidence

- CONFIRMED with E3; HIGH with E1.

## Severity

- MEDIUM–HIGH depending on the data.

## Safe Reproduction

- Local tests triggering errors with sensitive inputs; assert redaction.

## Root Cause

- Including request objects in errors; no redaction layer.

## Impact

- Credential/PII leakage, reconnaissance.

## Remediation

- Redact sensitive fields in errors/logs; generic client messages.

## Regression Test

- Tests asserting no sensitive values in error content.

## Common False Positives

- Errors with no sensitive fields (verify).

## Related Skills

- `stack-trace-exposure.md`
- `../observability/logging-security.md`
- `../database/database-error-leakage.md`

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

- OWASP Error Handling / Logging Cheat Sheets
- CWE-209
