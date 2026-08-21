# Skill: Iframe Embedding

## Purpose

Audit iframe usage: embedding untrusted content, framing policies, and clickjacking exposure.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: iframe, frame ancestors, clickjacking, embed.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find iframes: embedded third-party content, HTML/PDF previews, ads.
2. Check clickjacking: can your app be framed by others (X-Frame-Options/CSP frame-ancestors)?
3. Check sandbox attributes on iframes: allow-scripts without allow-same-origin?
4. Check frame communication: postMessage across iframes with origin checks.
5. Check framing-sensitive flows: banking/payment pages framable?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A clickjacking test (framing attempt) or missing frame headers discovered, plus iframe sandbox review.

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

Missing frame-ancestors/XFO and unsandboxed third-party iframes.

## Impact

Clickjacking on sensitive flows; embedded content compromise affecting the page.

## Remediation

Set frame-ancestors deny/sameorigin unless embedding is a feature, sandbox all third-party iframes, origin-check all messages.

## Regression Test

Header assertions and iframe-sandbox tests in CI.

## Common False Positives

Deliberate embedding via API documented and sandboxed.

## Related Skills

- clickjacking.md
- security-headers.md
- postmessage-analysis.md

## References

- OWASP Clickjacking Defense
- CWE-1021

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
