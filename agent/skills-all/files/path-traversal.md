# Skill: Path Traversal

## Purpose

Find path traversal: user input in file paths allowing reads/writes outside the intended directory (../, encodings, symlinks).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: path traversal, directory traversal, ../.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find filesystem sinks: file read/write, include, static file serving, download/export by filename, zip extraction.
2. Trace user input into path construction (join/+/f-string with names).
3. Check canonicalization: realpath after join, rejection of .. and absolute paths, Windows drive letters, UNC, encodings (%2e%2e%2f).
4. Test locally in a sandbox temp dir with canonicalization checks (benign payloads only).
5. Check symlinks within allowed dirs pointing outside (link-following).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test where a crafted path resolves outside the intended directory (canonical-path assertion fails), with the path code cited.

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

Path names composed from input without canonical containment checks after resolution.

## Impact

Arbitrary file read (source/config/secrets), file write (RCE potential for writable paths), DoS via special files.

## Remediation

Resolve and compare canonical paths against the allowed root; avoid user-supplied names in paths; use safe APIs and strict filename allowlists.

## Regression Test

Tests with ../, encoded, absolute, symlink variants asserting canonical containment.

## Common False Positives

Root-only access via chroot/container filesystems (partial); names validated to a safe charset; framework-level static serving with built-in traversal protection.

## Related Skills

- file-upload-security.md
- file-download-security.md
- canonicalization.md
- filesystem-permissions.md

## References

- OWASP Path Traversal
- CWE-22

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
