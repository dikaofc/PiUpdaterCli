# Skill: React-to-Shell (client RCE) Audit

## Purpose

Audit client-side frameworks (React/Next/Electron-style) for sinks that escalate XSS into code execution or shell: unsafe HTML rendering, postMessage RCE, and runtime bridges.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: react, dangerouslysetinnerhtml, next.js, client rce, xss to rce.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Catalog rendering sinks: dangerouslySetInnerHTML, refs writing innerHTML, DOMPurify misconfig, SVG/markup adoption, React-markdown with rehype-raw, Next.js script dangerouslySetInnerHTML.
2. Track user input (SSR props, URL, storage, postMessage) into them; classify context and encoding.
3. Look for escalation paths: Electron nodeIntegration, IPC postMessage handlers executing input, WebView addJavascriptInterface, eval-enabled plugins.
4. Verify with local browser automation that a benign marker executes, then reason statically whether execution can reach Node/OS APIs in the target runtime.
5. Check server-side rendering double-encoding: React hydration mismatches leaking unescaped HTML.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A browser-automation test proving sink execution plus a static trace of the capability boundary (browser vs Node vs shell) reachable from that sink.

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

Unsafe HTML-string rendering in client code, plus permissive runtime bridges (IPC/RPC) converting XSS into deeper access.

## Impact

XSS escalating to session theft or, in desktop/mobile hybrid runtimes, arbitrary code execution and shell access.

## Remediation

Eliminate dangerouslySetInnerHTML with untrusted data; scope postMessage/IPC to typed validated payloads with origin checks; sandbox WebViews.

## Regression Test

Automated DOM tests per sink-source pair and IPC-payload schema tests rejecting unexpected shapes.

## Common False Positives

Safe framework escaping (React text/attribute paths) reported as sinks; dangerouslySetInnerHTML with internal constant markup; sandboxed WebViews with no host bridge.

## Related Skills

- dom-xss.md
- xss-analysis.md
- unsafe-rendering.md
- frontend-data-exposure.md

## References

- React docs on dangerouslySetInnerHTML
- OWASP HTML5 Security (postMessage)
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
