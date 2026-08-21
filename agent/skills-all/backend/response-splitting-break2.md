# Skill: Response Splitting

## Purpose

Audit responses built from unvalidated input in headers/status lines enabling header injection or splitting.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: response splitting, header injection, crlf.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find places where input flows into Set-Cookie values, redirect headers, or custom headers.
2. Check CR/LF handling: are 
 sequences filtered or rejected?
3. Test locally: input containing %0d%0a observed in response headers.
4. Check status-line generation with input.
5. Check language/framework-level sanitization vs manual construction.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing injected header lines in a response, with the header-building code cited.

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

Trace code paths locally with debuggers/tests and mock services; reproduce with unit/integration tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

User input concatenated into response headers without validation.

## Impact

Header injection, cache poisoning, session cookie injection, smuggle-adjacent issues.

## Remediation

Never put raw input in headers, validate/encode header values, prefer framework header APIs that reject CR/LF.

## Regression Test

Tests asserting CR/LF payloads are rejected/neutral in every header sink.

## Common False Positives

Frameworks auto-neutralizing CR/LF in header APIs; inputs already validated to a safe charset.

## Related Skills

- crlf-injection.md
- header-injection-scanning.md
- set-cookie-injection.md

## References

- OWASP Header Injection
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
