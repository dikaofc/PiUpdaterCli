# Skill: Archive Processing

## Purpose

Audit archive extraction (zip/tar/gzip/rar): zip bombs, path traversal during extraction, symlink/hardlink escapes, and quota handling.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: archive, zip bomb, zip slip, extraction.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find archive extraction points: unzip/tarfile/extract, library extractors, user-provided archives.
2. Check entry-name validation during extraction (zip slip: ../../paths, absolute paths).
3. Check symlink/hardlink entries and whether extraction follows links outside the target.
4. Check decompression-bomb protections: entry count, total uncompressed size, compression-ratio limits.
5. Check per-entry size limits and total extracted-size caps.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local extraction test showing an archive escapes the target dir or consumes unbounded resources, with the extraction code cited.

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

Extraction without entry sanitization, symlink containment, or resource budgets.

## Impact

Arbitrary file write (zip slip), DoS (zip bomb), symlink-based file overwrite.

## Remediation

Validate each entry's canonical path within the target, reject links, enforce entry count + total size + ratio budgets, stream with limits.

## Regression Test

Tests with zip-slip archives, symlink entries, and bombs asserting safe rejection.

## Common False Positives

Extractors using libraries with built-in path checks (recent Python tarfile), size-limited pipelines, archives fully validated before extraction.

## Related Skills

- parser-security.md
- path-traversal.md
- file-upload-security.md
- resource-limit-analysis.md

## References

- OWASP Unrestricted File Upload
- CWE-22
- CWE-409

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
