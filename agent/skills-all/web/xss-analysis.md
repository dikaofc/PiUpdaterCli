# Skill: Cross-Site Scripting (XSS) Analysis

## Purpose

Find cross-site scripting: untrusted data rendered as HTML/executable context without proper contextual output encoding.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: xss, cross-site scripting, injection into html.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Locate rendering sinks: innerHTML, document.write, dangerouslySetInnerHTML, template interpolation, server-rendered HTML with {! !} or |safe, PHP echo, Java JSP EL, Rails html_safe.
2. Trace user input (query, body, stored values, URL fragments, headers) into those sinks.
3. Classify the context: HTML body, attribute, script string, style, URL — each needs different encoding.
4. Check whether escaping is applied and whether it matches the context (e.g., HTML-escaping a script context is bypassable).
5. Verify with a local browser harness / unit test using a benign marker (e.g., testing that quotes survive as data, not markup).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A data-flow trace into a rendering sink plus a local behavioral test in which a crafted input is interpreted as markup or script context.

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

Output encoding missing or mismatched to the insertion context, or unsafe sink (innerHTML/dangerouslySetInnerHTML) used with untrusted data.

## Impact

Session theft, account takeover, data theft, UI redressing, keylogging.

## Remediation

Context-aware output encoding (OWASP XSS Prevention Cheat Sheet), CSP as defense-in-depth, avoid unsafe sinks, sanitize only where rich content rendering is required.

## Regression Test

Automated tests at every sink with context-specific payloads (< > ", quote-in-attribute, script-context) asserting safe encoding.

## Common False Positives

Frameworks auto-escaping (React, Angular, EJS default, Vue mustache, Rails ERB) unless unsafe APIs are used; values validated to alphanumeric; CSP blocking execution without storage impact.

## Related Skills

- stored-xss.md
- reflected-xss.md
- dom-xss.md
- dom-sink-analysis.md
- unsafe-rendering.md

## References

- OWASP XSS Prevention Cheat Sheet
- CWE-79

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
