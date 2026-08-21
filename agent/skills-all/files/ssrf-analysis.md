# Skill: Server-Side Request Forgery (SSRF)

## Purpose

Find server-side request forgery: user input controlling URLs fetched server-side, including redirects, internal addresses, and cloud metadata (169.254.169.254).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: ssrf, server-side request forgery, url fetch.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find URL-fetching sinks: http libs, fetch/axios/requests, curl, SSRF-prone SDKs (image proxies, webhooks, PDF renderers, URL validators).
2. Trace user input (url param, webhook URLs, image src, import-by-URL, redirect following) into the fetch.
3. Check filtering: host allowlists (IP vs DNS rebinding), protocol allowlists (http/https only), blocked ranges (localhost, 169.254.169.254, link-local, 0.0.0.0), redirect handling.
4. Test locally: a local listener + the app configured to fetch a marker URL; probe whether internal/metadata addresses are fetchable through the app.
5. Verify which response data flows back to the user (read-based SSRF) vs blind.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing the app fetches an unauthorized internal/metadata address or follows an attacker redirect to do so, citing the fetch call and filter.

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

Test file handling with fixtures in a temp sandbox directory (paths, archives, uploads) and a local mock upload endpoint.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

URL-based functionality without strict destination validation at DNS-resolution time, or redirect-following bypassing filters.

## Impact

Internal network scan/attack, cloud metadata theft (credentials), local file reads via file://, blind data exfiltration.

## Remediation

Strict allowlists, resolve DNS and validate IP (reject private/link-local/metadata), block redirects or re-validate, no response feedback for internal targets, egress proxies with allowlists.

## Regression Test

Tests with localhost/169.254.169.254/redirect/internal-DNS targets asserting rejection.

## Common False Positives

Filters applying only to the initial hostname while redirects bypass; IPv6/encoded forms bypassing; input validated to URL shape but reaching non-fetch sinks (not SSRF).

## Related Skills

- url-validation.md
- network-exposure.md
- web-cache-poisoning.md
- file-download-security.md

## References

- OWASP SSRF Prevention Cheat Sheet
- CWE-918

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
