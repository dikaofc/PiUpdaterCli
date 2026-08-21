# Skill: Session Fixation

## Purpose

Detect session fixation: accepting client-chosen session IDs, or not rotating the session on authentication.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: session fixation, session id rotation, pre-auth session.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check whether the app accepts session IDs from the client (cookie parameter, URL) before auth.
2. Check whether the session ID rotates at login/privilege change.
3. Check pre-auth vs post-auth session continuity: same ID before and after login is a risk.
4. Check SSO/redirect flows that preserve a pre-auth session.
5. Test locally: login with a preset session ID and verify whether it persists post-auth.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test where a client-set session ID survives authentication (no rotation), with the session init code cited.

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

Missing session ID rotation on authentication or acceptance of client-derived session IDs.

## Impact

Attacker sets victim session ID → after victim logs in, attacker uses the authenticated session.

## Remediation

Always regenerate the session ID on authentication and privilege change; never accept client-chosen IDs (server-generated only).

## Regression Test

Tests asserting the session ID value changes after login from a preset value.

## Common False Positives

Cookies signed server-side so client-chosen IDs fail verification; frameworks rotating automatically.

## Related Skills

- session-management.md
- logout-security.md
- csrf-token-management.md

## References

- OWASP Session Fixation
- CWE-384

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
