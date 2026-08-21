# Skill: DOM XSS

## Purpose

Find DOM-based XSS: unsafe sinks fed by DOM sources without sanitization.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dom xss, sink, source, innerhtml.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Trace DOM sources: location, hash, search, document.referrer, postMessage, storage.
2. Trace sinks: innerHTML, outerHTML, document.write, insertAdjacentHTML, eval-family, href/srcdoc.
3. Map source→sink flows: direct or after transformation (encodeURIComponent, replace, substring).
4. Check library sinks: jQuery html(), Vue/React dangerouslySetInnerHTML/v-html, Angular bypassSecurityTrust.
5. Test locally: inject into each sink with a controlled browser page.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A source→sink flow demonstrated with a local test (alert or DOM marker), citing the sink line.

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

Sensitive DOM sinks receiving attacker-controlled values un-safely.

## Impact

Client-side session theft, keylogging, account actions on behalf of victim.

## Remediation

Use textContent/escape APIs, CSP as defense-in-depth, sanitize with DOMPurify where HTML is required, avoid dangerous sinks.

## Regression Test

Unit tests per sink with XSS payloads; CSP violation reports tested.

## Common False Positives

Sinks fed only by server-sanitized data or constant strings.

## Related Skills

- xss-analysis.md
- client-side-templating.md
- csp-analysis.md

## References

- OWASP DOM XSS Prevention
- PortSwigger DOM XSS
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
