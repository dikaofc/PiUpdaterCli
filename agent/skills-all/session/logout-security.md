# Skill: Logout Security

## Purpose

Audit logout: server-side session destruction, token invalidation, and client state cleanup.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: logout, session destroy, token invalidation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find the logout handler: does it destroy the server-side session/token?
2. Check all auth types: full logout invalidates access AND refresh tokens, SSO sessions.
3. Check client state: cookies cleared, local storage tokens removed, redirects safe.
4. Check CSRF-safe logout (POST) and that logout works even with expired sessions.
5. Check "logout everywhere" behavior on password change/suspension.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing session/token validity after logout (must be invalid), with the destroy code cited.

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

Drive a local app with a test client that captures cookies/tokens; assert cookie flags and expiry in automated tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Client-side-only logout or token not revoked at the server/store.

## Impact

Stolen tokens outlive logout; shared-device session persistence.

## Remediation

Server-side revocation (store delete, token blacklist), clear client state, apply to all token types, force re-login on privilege changes.

## Regression Test

Tests asserting tokens invalid after logout, including refresh tokens and multi-device sessions.

## Common False Positives

Stateless token designs with short TTL where revocation is documented as impossible (accept the trade-off consciously).

## Related Skills

- session-management.md
- session-expiration.md
- token-replay.md

## References

- OWASP Session Management Cheat Sheet
- CWE-613

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
