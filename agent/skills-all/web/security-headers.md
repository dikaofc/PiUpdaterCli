# Skill: Security Headers

## Purpose

Review the security-header baseline (CSP, HSTS, frameguard, nosniff, Referrer-Policy, Permissions-Policy) for completeness and correctness.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: security headers, csp, hsts, nosniff, referrer.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List headers served on HTML responses: CSP, Strict-Transport-Security, X-Content-Type-Options, X-Frame-Options/frame-ancestors, Referrer-Policy, Permissions-Policy, Cache-Control.
2. Check HSTS: present, includeSubDomains/preload where appropriate, over all HTTPS responses.
3. Evaluate CSP: restrictive enough (no unsafe-inline/unsafe-eval unless justified), correct on all pages.
4. Check Cache-Control on sensitive/authentication responses (no-store).
5. Verify headers apply to error pages and redirects too.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A header inventory per response class with gaps cited; claims of missing headers verified with a local request.

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

Header policy defined partially or inconsistently (e.g., only on the main route, not on error/auth pages).

## Impact

Reduced defense-in-depth: XSS/redirect/framing/sniffing easier.

## Remediation

Centralize header policy in middleware/IaC; set HSTS early; iteratively tighten CSP; add nosniff, frame denial, no-store on sensitive responses.

## Regression Test

Header assertions in tests for every UI/auth/API response class.

## Common False Positives

Headers set by an upstream proxy/CDN not visible in the app repo; CSP report-only counted as enforced (flag as partial).

## Related Skills

- content-security-policy.md
- clickjacking.md
- cookie-security.md

## References

- OWASP Secure Headers Project
- CWE-693

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
