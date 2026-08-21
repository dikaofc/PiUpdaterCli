# Skill: File Upload Security

## Purpose

Audit upload functionality: content validation, storage placement, execution prevention, size limits, and downstream consumers of uploaded files.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: file upload, upload validation, polyglot, executable upload.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find upload endpoints: multipart handlers, base64 body uploads, S3/object-storage uploads.
2. Check validation: extension, MIME (client vs server-detected), magic bytes, file signatures, filename sanitization.
3. Inspect storage: uploads dir under webroot with execution enabled? Object storage public-read? Deterministic names (overwrite/guess)?
4. Check downstream consumers: image processors (polyglot/ImageMagick/decompression bombs), parsers of CSV/XML/archives from uploads.
5. Verify size limits and quota enforcement (DoS via unlimited uploads).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a dangerous file type stored in an executable/public location, or a polyglot/oversized file reaching a vulnerable consumer, with the validation/storage code cited.

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

Client-trusted validation, missing content inspection, or storage placement allowing execution/public access.

## Impact

Webshell/remote code execution (webroot execution), stored XSS via uploaded HTML, malware hosting, storage exhaustion.

## Remediation

Server-side magic-byte validation, rename to random names, store outside webroot (or denied execution), scan, strict size limits, treat every upload as untrusted in consumers.

## Regression Test

Tests uploading .php/.html/polyglot/oversized/symlink filenames asserting rejection or safe storage and safe consumption.

## Common False Positives

Uploads restricted to images with magic-byte checks and non-executable storage; object storage private with signed URLs and per-upload authz.

## Related Skills

- path-traversal.md
- mime-confusion.md
- parser-security.md
- wp2shell.md

## References

- OWASP File Upload Cheat Sheet
- CWE-434
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
