# Skill: Logging Security

## Purpose

Analyze logging security: sensitive data in logs, log injection, coverage of
security events, and volume safety.

## Scope

- Included: sensitive values, event coverage, redaction, volume bounds.
- Excluded: audit integrity (`audit-trail-analysis.md`).
- Layers: logging.

## Trigger Conditions

- Claims of "no secrets in logs" to verify.
- Logging changes.

## Inputs

- source code (log statements)
- log configs

## Investigation Method

1. Identify entry points: log calls.
2. Identify trust boundaries: data → logs.
3. Track relevant data: logged values.
4. Identify validation: redaction.
5. Identify security-sensitive operations: N/A.
6. Inspect authorization: N/A.
7. Inspect error handling: errors logging sensitive data.
8. Inspect tests: log-content tests.
9. Determine exploitability or correctness impact: leakage.
10. Validate the finding: render log lines locally.

## Evidence Requirements

- E1: log code.
- E3: test showing sensitive values in rendered logs.

## Confidence

- CONFIRMED with E3.

## Severity

- MEDIUM–HIGH depending on data.

## Safe Reproduction

- Local log rendering tests.

## Root Cause

- Logging raw inputs/headers; no redaction.

## Impact

- Credential/PII exposure in logs.

## Remediation

- Redact sensitive fields; structured logging; field allow-lists.

## Regression Test

- Log-content tests asserting no sensitive values.

## Common False Positives

- Log systems redacting at the sink (verify).

## Related Skills

- `audit-trail-analysis.md`
- `../injection/log-injection.md`
- `../checklists/logging.md`
- `../patterns/secure-logging.md`

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

- OWASP Logging Cheat Sheet
- CWE-532
