# Skill: Mobile WebView Security

## Purpose

Audit WebView usage in mobile apps: JavaScript bridge exposure, file access, and mixed content.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: webview, javascript bridge, addjavascriptinterface, remote content.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find WebView instances and their settings: JavaScript enabled, file access, allowUniversalAccessFromFileURLs.
2. Check JS bridges (addJavascriptInterface, evaluateJavascript surfaces): what native APIs are exposed?
3. Check remote content loading: unvalidated URLs rendered in WebView.
4. Check navigation: shouldOverrideUrlLoading allowing javascript: or unknown schemes?
5. Check certificate handling in WebView loads.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- WebView settings and bridge code cited; an exposed bridge or universal file access is a finding.

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

Broad WebView permissions and bridge methods reachable from any loaded content.

## Impact

RCE-adjacent native API abuse from malicious pages, file theft, token theft.

## Remediation

Disable unnecessary settings, restrict bridges to validated content (allowlist), no universal file access, validate every URL and scheme.

## Regression Test

Instrumented tests asserting bridge exposure only for trusted origins.

## Common False Positives

WebViews loading only bundled assets with bridges disabled.

## Related Skills

- mobile-ssl-pinning.md
- deep-link-validation.md
- xss-analysis.md

## References

- Android WebView security docs
- iOS WKWebView risks
- CWE-749 (exposed dangerous method)

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
