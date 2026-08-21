# Skill: Audit Trail Analysis

## Purpose

Analyze audit trails: coverage of security-relevant events, actor identity,
immutability, and access control of audit data.

## Scope

- Included: event coverage, actor attribution, tamper resistance, retention.
- Excluded: sensitive data in logs (`logging-security.md`).
- Layers: logging/audit.

## Trigger Conditions

- Compliance requirements.
- Claims of "audited" to verify.

## Inputs

- source code (audit events)
- log configs

## Investigation Method

1. Identify entry points: security events.
2. Identify trust boundaries: actor → event.
3. Track relevant data: event attributes.
4. Identify validation: coverage.
5. Identify security-sensitive operations: privileged actions.
6. Inspect authorization: N/A.
7. Inspect error handling: N/A.
8. Inspect tests: event tests.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: event trigger tests.

## Evidence Requirements

- E1: audit code.
- E3: tests demonstrating coverage/attribution.

## Confidence

- CONFIRMED with E3.

## Severity

- MEDIUM (compliance/forensics).

## Safe Reproduction

- Local event tests.

## Root Cause

- Missing events; client-claimed identity.

## Impact

- Blind spots, accountability gaps.

## Remediation

- Server-side actor attribution; tamper-resistant storage; retention.

## Regression Test

- Event-coverage tests.

## Common False Positives

- Events logged at gateway (verify).

## Related Skills

- `logging-security.md`
- `../authorization/admin-function-protection.md`
- `../checklists/logging.md`

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
- NIST SP 800-92
