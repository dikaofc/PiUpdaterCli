# Skill: HTTP Response Splitting

## Purpose

Find response splitting: CRLF injection into responses letting an attacker craft additional headers/responses (ties to header injection and cache poisoning).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: response splitting, crlf response, header smuggling.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find raw response-writing paths: manual HTTP responses, redirect targets, header values from user input, proxy rewriting.
2. Test locally with a raw socket: send a value containing %0d%0a and inspect exact response bytes.
3. Check downstream caches/proxies interpreting the split as separate responses.
4. Verify whether later responses (including prefixed attacker content) can be served to victims.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A raw-HTTP local test showing user CRLF bytes produce additional header/body lines in the response stream.

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

CR/LF unvalidated in values that become part of the response line structure.

## Impact

Cache poisoning, XSS via injected response, response desync.

## Remediation

Reject CR/LF in all header/status inputs; validate redirect targets; normalize at the edge.

## Regression Test

Raw-socket tests asserting CRLF payloads cannot alter response structure.

## Common False Positives

Frameworks stripping CRLF in header APIs; input not reaching response-structure positions.

## Related Skills

- header-injection.md
- crlf-injection.md
- request-smuggling.md
- cache-poisoning.md

## References

- OWASP Response Splitting
- CWE-113

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
