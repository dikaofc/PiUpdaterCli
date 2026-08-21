# Skill: File Download Security

## Purpose

Audit download/export functionality: path control, content-type safety, content-disposition, symlink exposure, and range handling.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: file download, download security, content-disposition.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find download/export endpoints: streamed files, X-Sendfile/X-Accel-Redirect, signed-URL generation, attachment rendering.
2. Check filename/path source: user-supplied filenames (traversal/overwrite) and authorization of the requested file (can user B download user A's file?).
3. Verify authorization is checked per object (pivot to IDOR analysis).
4. Check Content-Type/Disposition: inline vs attachment, nosniff, charset, RFC 5987 filename encoding.
5. Check range/partial-request handling and symlink following.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a user can download an unauthorized object or the response headers are unsafe, with the handler and authorization cited.

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

Test file handling with fixtures in a temp sandbox directory (paths, archives, uploads) and a local mock upload endpoint.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Missing per-object authorization, or unsafe header/path handling in the download handler.

## Impact

Unauthorized data disclosure, stored-XSS-by-download, server file disclosure.

## Remediation

Per-object authorization checks, server-derived safe filenames, attachment disposition with nosniff, canonicalization of the served path.

## Regression Test

Tests asserting cross-user downloads fail and headers are correct for every download type.

## Common False Positives

Public files intended for anonymous download; filenames scrubbed and mapped server-side.

## Related Skills

- path-traversal.md
- idor-analysis.md
- resource-ownership.md
- file-upload-security.md

## References

- OWASP File Download
- CWE-22
- CWE-625

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
