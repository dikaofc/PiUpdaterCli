# Skill: Cookie Security

## Purpose

Audit cookie attributes: Secure, HttpOnly, SameSite, Domain/Path scope, prefix usage, and value integrity.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: cookie security, httponly, samesite, secure flag.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory cookies: session, CSRF, tracking, preferences — and their attributes.
2. Check Secure (HTTPS-only), HttpOnly (non-JS readable) on session/auth cookies.
3. Check SameSite on all cookies (Lax/Strict where appropriate).
4. Check Domain/Path scope: scoped minimally, no parent-domain leakage.
5. Check integrity: stateful values signed server-side; __Host-/__Secure- prefixes where supported.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A cookie inventory from a local session with attribute values cited; any missing attribute is a finding candidate.

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

Framework defaults or manual Set-Cookie without security attributes.

## Impact

Session theft via XSS (no HttpOnly), CSRF (no SameSite), MITM theft (no Secure).

## Remediation

Set Secure+HttpOnly+SameSite on all session cookies, minimal Domain/Path, sign stateful cookie values.

## Regression Test

Tests asserting cookie flags on every Set-Cookie.

## Common False Positives

Non-sensitive preference cookies without HttpOnly (usually acceptable if not auth-bearing).

## Related Skills

- session-management.md
- csrf-token-management.md
- security-headers.md

## References

- OWASP Session Management Cheat Sheet
- MDN Set-Cookie
- CWE-1004 (sensitive cookie without Secure)

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
