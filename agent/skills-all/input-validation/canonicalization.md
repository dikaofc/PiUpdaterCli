# Skill: Canonicalization

## Purpose

Detect cases where the same logical input can be represented in multiple ways and the code treats representations inconsistently (path, URL, ID, string).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: canonicalization, normalization, equivalent input.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify inputs with multiple representations: file paths (./, ../, //, symlinks), URLs (unicode, percent-encoding, case), IDs (hex vs int, base64 variants), strings (NFC vs NFD).
2. Check whether the code uses a single canonical form or compares raw representations.
3. Test equivalent inputs that differ textually but resolve identically (e.g., /etc/passwd, /etc/./passwd, /etc//passwd).
4. Check encoders: does validation run before or after normalization? Does a decode-after-validate bypass exist?
5. Verify storage/retrieval uses the same canonical form as validation.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- One concrete pair of equivalent-but-different inputs that produce different security outcomes (or bypass validation), with the compare line cited.

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

Comparisons/allowlists applied to non-canonical forms while the actual resolution uses another form.

## Impact

Path traversal, URL-filter bypass (SSRF), duplicate-account/object confusion (canonical ID mismatch), or auth bypass.

## Remediation

Canonicalize early (realpath, URL.normalize, Unicode NFC), validate the canonical form, and use canonical forms as keys.

## Regression Test

Tests with equivalent-form pairs (./, encoded, unicode, case) asserting identical handling.

## Common False Positives

Representations that never reach the sensitive operation; framework-level canonicalization already applied upstream.

## Related Skills

- encoding-validation.md
- unicode-handling.md
- path-traversal.md
- url-validation.md

## References

- OWASP Canonicalization, Encoding Language
- CWE-177 (canonicalization errors)
- CWE-180 (incorrect behavior order)

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
