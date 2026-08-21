# Skill: DOM XSS

## Purpose

Find DOM-based XSS: client-side JavaScript reads untrusted sources (location, postMessage, storage) and passes them to dangerous sinks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dom xss, client-side xss, sink source.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List client-side sources: window.location, document.referrer, postMessage, localStorage/sessionStorage, URLSearchParams, document.cookie, window.name.
2. List dangerous sinks: innerHTML, document.write, eval, setTimeout with string, jQuery html/append, template tags, srcdoc.
3. Trace source to sink within client bundles (static analysis + grep).
4. Understand cross-page flows: a step in page A flows through location.hash into a page B sink.
5. Verify with local browser automation that evaluates the sink with a benign marker and detects execution.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A browser-automation test proving a crafted URL/message reaches a dangerous sink, with the source and sink lines cited.

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

Client code moving untrusted values into sinks instead of textContent/attribute APIs or framework-safe binding.

## Impact

Session theft and account takeover without any server-side flaw — WAFs and server CSP cannot see it.

## Remediation

Use textContent/setAttribute safe APIs, framework escaping, no HTML-string sinks; validate postMessage origin; hardened CSP.

## Regression Test

Automated DOM-XSS assertions (jsdom or Playwright) per source-sink pair.

## Common False Positives

Sources validated to safe format before reaching sinks; values only reaching safe APIs; sinks in dead code.

## Related Skills

- xss-analysis.md
- dom-sink-analysis.md
- unsafe-rendering.md
- frontend-data-exposure.md

## References

- OWASP DOM XSS
- CWE-79
- PortSwigger DOM-based research

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
