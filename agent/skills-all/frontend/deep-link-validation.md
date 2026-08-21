# Skill: Deep Link Validation

## Purpose

Audit mobile deep links/URL schemes: unvalidated schemes, intent injection, and sensitive-action triggers.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: deep link, url scheme, intent, deeplink hijack.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory declared schemes/handlers (Android intents, iOS universal links).
2. Check intent filters: does a dangerous or over-broad scheme reach sensitive handlers?
3. Check parameter handling: URLs parsed and used for navigation/execution?
4. Check verification: universal links AASA/applinks verified?
5. Check default-handler conflict: do other apps claim the same scheme?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A manifest/Info.plist/plist review with handlers and their actions, plus a crafted-link test on a device/staged env.

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

Broad intent filters or unvalidated URL-driven actions.

## Impact

App takeover via crafted links, shared-account attacks, sensitive action triggers.

## Remediation

Narrow schemes, validate host/path allowlists, use verified universal links, no sensitive actions via raw scheme data.

## Regression Test

Instrumented tests asserting non-allowlisted links are ignored.

## Common False Positives

Schemes with no sensitive actions; platform-verified universal links.

## Related Skills

- open-redirect.md
- mobile-webview.md

## References

- Android intent filters docs
- Apple universal links
- CWE-939 (improper authorization in handler)

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
