# Skill: CSRF Token Management

## Purpose

Audit CSRF token lifecycle: generation, binding to session, validation on state-changing requests, and possible token leaks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: csrf token, anti-csrf, token binding.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find token generation (per-session, per-request?) and validation middleware.
2. Check token binding to the session: token must not be shareable across sessions.
3. Check validation coverage: all state-changing methods? Non-form content types?
4. Check token leakage: in URLs, logs, APIs, or readable to JS (HttpOnly).
5. Check reissuance on session rotation (token tied to old session becomes stale).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local cross-origin request succeeding without a valid token, or a token usable across sessions, with the validation code cited.

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

Token validation skipped for some content types/methods, or tokens not session-bound.

## Impact

CSRF on protected flows, token theft via leakage.

## Remediation

Session-bound random tokens validated on every mutating request (except safe public APIs), HTTP-only storage, SameSite as defense-in-depth.

## Regression Test

Matrix tests: mutating requests with missing/wrong/cross-session tokens asserted rejected.

## Common False Positives

APIs with Bearer auth (CSRF-immune) not needing tokens; SameSite+Origin checks replacing tokens intentionally.

## Related Skills

- csrf-analysis.md
- session-management.md
- cookie-security.md

## References

- OWASP CSRF Prevention Cheat Sheet
- CWE-352

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
