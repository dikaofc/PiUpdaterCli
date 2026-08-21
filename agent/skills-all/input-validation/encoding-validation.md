# Skill: Encoding Validation

## Purpose

Verify that input encoding is detected, normalized, and validated consistently, preventing multi-encoding bypass.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: encoding, charset, percent-encoding, base64, hex.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Determine which encodings the framework decodes by default (percent, base64, hex, unicode, HTML entities, JSON escapes).
2. Check whether validation happens on the final decoded value or an intermediate encoded value (decode-after-validate bypass).
3. Test double-encoding: %252e%252e%252f, %uXXXX, overlong UTF-8, mixed encodings in one value.
4. Check charset handling at the protocol level (Content-Type, charset param) vs what the parser assumes.
5. Verify encoding-specific sinks (SQL charset, shell quoting, HTML charset) receive correctly encoded data.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A valid encoded variant of an input that bypasses validation yet reaches the sink in dangerous decoded form.

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

Validation applied before full decoding, or no canonical decoding step between boundary and sink.

## Impact

Bypass of filters (XSS, SQLi, path traversal, SSRF) via encoding tricks.

## Remediation

Canonical decoding once at the boundary, validate the decoded value, re-encode for each sink context, and set explicit charsets.

## Regression Test

Tests with single/double/unicode-encoded payloads asserting consistent rejection at the sink.

## Common False Positives

Encodings the framework correctly rejects upstream; validation after full decode that makes the encoded variant harmless.

## Related Skills

- canonicalization.md
- unicode-handling.md
- input-validation.md
- xss-analysis.md

## References

- OWASP Encoding
- CWE-116 (improper encoding of output)
- PortSwigger "How to prevent XSS with output encoding"

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
