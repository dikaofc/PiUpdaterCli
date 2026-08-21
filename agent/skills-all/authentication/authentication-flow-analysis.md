# Skill: Authentication Flow Analysis

## Purpose

Trace the full authentication flow — login, session issuance, verification, refresh, logout — for bypasses, fixations, and logic flaws.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: auth flow, login flow, authentication bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map every auth entry: login (password, OAuth, SSO, MFA), token refresh, session validation middleware, impersonation/delegation flows.
2. Trace how the session/token is issued and bound to the principal (revocability, expiry).
3. Check verification: where identity is established from credentials/session — server-side only?
4. Check alternate paths: "remember me", magic links, OAuth state, account linking — each can bypass the main flow.
5. Test locally with disposable accounts: login, refresh, logout, and replay sequences.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A flow diagram of issue→verify→refresh→logout with the principal-binding code cited, plus behavioral tests on the critical transitions.

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

Test flows against a local auth service with disposable accounts; never brute-force real accounts.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Identity established or bound at one layer while another layer (or path) creates sessions without it.

## Impact

Account takeover, session hijacking, authentication bypass.

## Remediation

Single unified auth middleware, server-side principal binding, revocable sessions, consistent checks on all alternate paths.

## Regression Test

Flow-level integration tests covering login→refresh→logout→replay across every auth path.

## Common False Positives

Flows that look similar but are intentionally separate (API-key vs user login); sessions cryptographically bound to device and user.

## Related Skills

- session-authentication.md
- login-state-machine.md
- token-generation.md
- api-authentication.md

## References

- OWASP Authentication Cheat Sheet
- NIST SP 800-63B

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
