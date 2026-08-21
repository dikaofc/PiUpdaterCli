# Skill: Audit Trail Maintenance

## Purpose

Audit logging and audit trails: completeness of security events and log integrity.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: audit trail, logging, log integrity.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify security events that must be logged: auth success/failure, authz denials, admin actions, privilege changes, data exports.
2. Check log coverage: are these events actually recorded (with actor, action, resource)?
3. Check log integrity: tamper resistance, centralized collection, retention.
4. Check sensitive data in logs: PII/tokens redacted.
5. Check alerting: critical events trigger alerts.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A log-coverage table (event × logged × alert) with a log-integrity assessment.

Minimum bar: **static evidence (E1)** to open a line of inquiry; **behavioral evidence (E3)** or better for a confirmed report. See `context/evidence-model.md`.

## Confidence

Use one of:

- **CONFIRMED** — behavior reproduced and root cause validated (E3+).
- **HIGH CONFIDENCE** — strong static + data-flow evidence, controlled verification pending.
- **MEDIUM CONFIDENCE** — plausible path but some assumptions remain unverified.
- **LOW CONFIDENCE** — theoretical risk; requires validation.
- **FALSE POSITIVE** — disproven or mitigated after analysis.

Confidence is independent of severity (see `context/confidence-model.md`).

## Severity

Assess severity from actual **impact + exploitability + required privileges + interaction + affected scope + data sensitivity** (see `context/severity-model.md`). Do not automatically label this class CRITICAL. A finding must earn its severity from evidence.

Typical range for this skill: LOW–HIGH depending on reachability and data sensitivity.

## Safe Reproduction

Review logging/telemetry code locally; redact anything sensitive before sharing.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Missing or insecure logging of security events.

## Impact

No forensic trail after incidents; inability to detect breaches.

## Remediation

Log required events consistently, centralize with access control, redact secrets, alert on criticals, protect log integrity (WORM).

## Regression Test

Tests asserting required events are emitted with correct fields.

## Common False Positives

Non-security events (debug trace noise) not requiring retention.

## Related Skills

- logger-injection.md
- data-protection.md
- incident-response-preparedness.md

## References

- OWASP Logging Cheat Sheet
- CWE-778 (insufficient logging)

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected (E1–E5 level recorded)
- [ ] Severity assigned (impact-based)
- [ ] Confidence assigned (separate from severity)
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed
