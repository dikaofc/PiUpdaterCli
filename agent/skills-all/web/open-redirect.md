# Skill: Open Redirect

## Purpose

Find open redirects: user-controlled redirect targets (next, return, callback, url params) that send users to attacker origins.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: open redirect, url redirect, next param.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find redirect sinks: Location header from user input, window.location assignment, meta refresh, 302/303 responses driven by params.
2. Trace input into redirect targets; check target validation (protocol, host).
3. Test locally: submit targets like //evil.com, https://evil.com, javascript: and observe the emitted Location.
4. Follow deeper flows: OAuth callback handling, SSO post-login redirects, payment return URLs.
5. Classify severity by use (phishing vs token leak in redirect query).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local response showing Location set to an attacker-chosen origin from a supplied parameter, with the redirect code cited.

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

Use a local test app with deliberately vulnerable routes, or browser automation against a sandbox instance you control.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Redirect target derived from user input without host allowlisting or protocol validation.

## Impact

Phishing (trust-brand page to attacker), OAuth authorization-code/token leak via open redirect in callback flows.

## Remediation

Redirect only to relative paths or an allowlisted origin set; never to schemes outside http(s); reject backslashes and protocol-relative URLs.

## Regression Test

Tests feeding //, https://evil, javascript:, backslash variants to every redirect point, asserting safe fallback.

## Common False Positives

Redirect targets validated against a strict allowlist; redirects always to fixed internal paths.

## Related Skills

- url-validation.md
- ssrf-analysis.md
- header-injection.md
- oauth-analysis.md

## References

- OWASP Unvalidated Redirects
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
