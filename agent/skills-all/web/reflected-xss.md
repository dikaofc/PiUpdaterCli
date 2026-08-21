# Skill: Reflected XSS

## Purpose

Find reflected XSS: input echoed into the response without encoding, executed in the victim browser.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: reflected xss, non-persistent xss, echo.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find response-reflecting sinks: query params, search results, error pages, redirect targets echoed into HTML/JS.
2. Trace user input to response output with minimal transformation.
3. Check encoding at the reflection point and the global filter posture.
4. Test locally per sink: feed a benign marker and confirm whether markup survives into the response.
5. Note interaction requirements (user must follow a crafted link) for severity.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local response test where untrusted input bytes appear unencoded in the HTML context with the echo line cited.

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

Reflecting input into the response without context-appropriate encoding.

## Impact

Session theft via crafted links, phishing amplification.

## Remediation

Contextual encoding at reflection; reject/redirect unexpected patterns; CSP; encode errors.

## Regression Test

Sink-by-sink tests with payloads asserted non-executable in the returned HTML/JS.

## Common False Positives

Input that never reaches the response unencoded; JSON APIs returning data (not HTML); WAF-layer blocking verified.

## Related Skills

- xss-analysis.md
- security-headers.md
- content-security-policy.md

## References

- OWASP XSS (reflected)
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
