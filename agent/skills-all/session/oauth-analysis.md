# Skill: OAuth2 Analysis

## Purpose

Audit OAuth2 flows: redirect URI validation, state handling, code/token exchange, scope enforcement, and PKCE.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: oauth2, redirect uri, authorization code, pkce, state.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map each OAuth flow (authorization code, implicit, client credentials, device) in use.
2. Check redirect_uri validation: exact match, no open redirect abuse, no path/wildcard looseness.
3. Check state parameter: generated, bound to the session, verified on return.
4. Check authorization code/CSRF binding: code exchanged with the same client (and PKCE for public clients).
5. Check scope enforcement: server-side scope checks, token leakage in URLs/history, and Refresh token rotation.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local flow test showing redirect-URI looseness, missing state, or code replay, with the handler code cited.

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

Redirect URI validated loosely or state/PKCE missing, letting attackers capture codes/tokens.

## Impact

Account takeover via code interception, CSRF login, token theft.

## Remediation

Exact redirect_uri matching, mandatory state with verification, PKCE for public clients, short-lived codes, scope checks, token rotation.

## Regression Test

Flow tests asserting exact URI match, state verify failure, code single-use.

## Common False Positives

OAuth handled by a certified IdP SDK with secure defaults; internal-only OAuth (first-party) with documented model.

## Related Skills

- jwt-analysis.md
- oidc-analysis.md
- open-redirect.md
- token-replay.md

## References

- OAuth 2.0 RFC 6749 (+ RFC 9707 PKCE)
- OWASP OAuth Cheat Sheet
- CWE-601

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
