# Skill: WebSocket Security

## Purpose

Audit WebSocket endpoints: origin validation, authentication at connect, message-level authorization, and injection via frames.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: websocket, ws, origin check, message auth.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find WebSocket endpoints (ws/wss upgrade handlers) and their connect-time checks.
2. Check origin validation: cross-site WebSocket hijacking if only cookies authenticate.
3. Check authentication happens at connect (handshake) and messages are authorized per operation.
4. Check message parsing: JSON/XML frame injection into downstream sinks (SQLi/XSS via pushed content).
5. Check subscriptions: can a client subscribe to channels/rooms it does not own (cross-tenant leaks)?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a handshake with foreign Origin succeeds with cookie auth (CSWSH), or a subscription/message reaches unauthorized data.

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

Use a local API with seeded mock data and a scratch test user/tenant; assert with integration tests, not against production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Handshake lacking origin validation, or per-message authorization missing.

## Impact

Cross-site WebSocket hijacking, unauthorized data streams, injection via frames.

## Remediation

Validate Origin at handshake, require tokens in the handshake, authorize each message/subscription server-side, treat frames as untrusted input.

## Regression Test

Handshake and subscription tests asserting origin/authorization enforcement.

## Common False Positives

WebSockets used only for public broadcast; handshake tokens enforced with origin checks.

## Related Skills

- csrf-analysis.md
- api-authorization.md
- api-data-exposure.md
- api-authentication.md

## References

- OWASP HTML5 Security (WebSockets)
- CWE-1385 (missing origin validation in WebSocket)

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
