# Skill: Untrusted Input Analysis

## Purpose

Identify all inputs that arrive from outside the trust boundary and confirm whether each is validated before use in sensitive operations.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: untrusted input, external input, boundary validation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List input sources across all boundaries: HTTP body/query/headers/cookies, file uploads, webhooks, queue messages, CLI args, env vars, config files, DNS responses.
2. For each source determine its trust level and whether it crosses a boundary before use.
3. Find the validation function (if any) applied to each input and what it guarantees (type, length, charset, range, allowed values).
4. Check validation bypass: validation on the client, validation of the wrong field, decode-after-validate, type coercion bypass.
5. Trace validated input to sinks (query, shell, render, file, URL fetch) and verify the validation actually protects that sink.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Input inventory with trust level, validation function cited, and sink. Claim "unvalidated input reaches sink" needs the exact code path from source to sink.

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

Build local fixtures with a test HTTP server or CLI harness that feeds controlled payloads (valid, boundary, malformed) and assert behavior in unit tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Validation missing at the boundary is the root defect; look for where validation was expected but absent or applied to a clone of the data.

## Impact

Unvalidated input is the enabler of injection, XSS, path traversal, SSRF, and many logic flaws.

## Remediation

Validate at the boundary with allowlists (type, length, format), canonicalize, and re-validate after decoding; fail closed on unknown values.

## Regression Test

Tests feeding boundary, malformed, and hostile inputs to each entry point, asserting safe rejection or safe handling.

## Common False Positives

Input validated elsewhere in the flow counted as unvalidated; validation applied to a sanitized copy while the raw value is used at the sink.

## Related Skills

- boundary-validation.md
- schema-validation.md
- encoding-validation.md
- api-input-boundaries.md

## References

- OWASP Input Validation Cheat Sheet
- CWE-20 (improper input validation)
- CWE-1023 (incomplete validation)

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
