# Skill: Session Management

## Purpose

Audit the session lifecycle: issuance, storage, transport, expiry, renewal, and revocation.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: session management, session lifecycle, session store.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find session creation (login, SSO, magic link) and the session store (memory, Redis, DB, cookie-only).
2. Check session ID generation: crypto-random, entropy, length.
3. Check transport: Secure cookie, HTTPS only, no leakage in URLs/logs/referrers.
4. Check renewal: fixed sessions (same ID forever) vs rotation on privilege change.
5. Check revocation: logout kills the server-side session; suspension kills all sessions.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A lifecycle map with the store and generation code cited, plus behavioral tests for logout-rotation-revocation.

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

Session IDs not rotated, stored insecurely, or not revocable server-side.

## Impact

Session fixation, hijacking, persistence after logout/compromise.

## Remediation

Crypto-random session IDs, rotate on login/privilege change, Secure/HttpOnly/SameSite cookies, server-side revocation, absolute+sliding expiry.

## Regression Test

Tests asserting rotation on privilege change, revocation on logout, and cookie flags.

## Common False Positives

Frameworks with built-in session rotation configured properly; stateless designs analyzed under jwt-analysis.

## Related Skills

- session-expiration.md
- logout-security.md
- cookie-security.md
- session-fixation.md

## References

- OWASP Session Management Cheat Sheet
- CWE-331 (insufficient entropy)

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
