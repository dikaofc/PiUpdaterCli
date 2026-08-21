# Skill: Frontend Security Headers

## Purpose

Audit headers delivered to the browser: HSTS, CSP, Framing, Referrer-Policy, Permissions-Policy, and COEP/COOP.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: security headers, hsts, referrer policy, permissions policy.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Fetch the app response headers and compare against the baseline set.
2. Check each header: HSTS (includeSubDomains, preload), CSP (strength), X-Frame-Options or frame-ancestors, Referrer-Policy, Permissions-Policy, COOP/COEP, X-Content-Type-Options.
3. Check header consistency across all entry points (CDN, WWW, API).
4. Check CSP report-uri configuration and violation handling.
5. Verify removal at all layers (proxy, CDN edge, app).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A header capture from a local/controlled fetch with missing/weak headers noted.

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

Inspect bundles locally; run browser automation against a local build. Never exfiltrate data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Headers not applied at the edge or removed by layers.

## Impact

Elevated XSS/clickjacking/MIMI risk despite code being otherwise sound.

## Remediation

Set the full header set at the terminating edge, CSP with report-only rollout, CI header assertions.

## Regression Test

CI tests asserting the header set on all entry endpoints.

## Common False Positives

Headers managed by a CDN/provider with verified presence; non-browser API endpoints not needing browser headers.

## Related Skills

- security-headers.md
- csp-analysis.md
- clickjacking.md

## References

- OWASP Secure Headers Project
- MDN security headers

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
