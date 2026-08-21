# Skill: History and Referrer Leakage

## Purpose

Audit sensitive data leakage via URL history, referrers, and client-side caches.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: history leakage, referrer, token in url, browser cache.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Search for sensitive data in URLs: tokens, PII, API keys in query params.
2. Check Referer leakage: outgoing links receive the full URL?
3. Check browser cache: sensitive GET payloads cached by proxy/browser.
4. Check autofill/history: sensitive forms retained (credit cards, passwords).
5. Check SPA routing: secrets in hash/fragment surviving navigation.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A URL/referer audit with concrete sensitive-in-URL examples and a referer capture test.

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

Security tokens or PII placed in URLs (GET or fragments).

## Impact

Leakage to third parties (referrer), proxies, logs, history.

## Remediation

Move tokens to headers/body, Referrer-Policy: no-referrer on sensitive pages, cache-control private/no-store, disable form autocomplete for sensitive fields.

## Regression Test

Tests asserting no token-in-URL patterns and referrer policies.

## Common False Positives

Public/shared URLs with no sensitive payload by design.

## Related Skills

- cache-poisoning.md
- sensitive-data-exposure.md
- frontend-api-security.md

## References

- OWASP URL safety
- CWE-598 (use of GET with sensitive strings)

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
