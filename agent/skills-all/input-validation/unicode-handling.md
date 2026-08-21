# Skill: Unicode Handling

## Purpose

Find unicode-specific validation and comparison flaws: normalization, homoglyphs, bidi, overlong encodings, and width tricks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: unicode, normalization, NFC NFD, homoglyph, bidi.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check normalization policy: NFC/NFD/NFKC/NFKD used? Where? Applied before validation and comparisons?
2. Test homoglyph IDs/usernames (Cyrillic vs Latin o) reaching allowlists, ownership checks, and routing.
3. Look for bidi control characters (U+202E and friends) in logs, filenames, and rendered content.
4. Test overlong/illegal UTF-8 sequences and lone surrogates through parsers and validators.
5. Verify length limits are measured in characters or bytes consistently (limit bypass via multi-byte chars).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- One unicode variant that bypasses a check or causes confusion (same-display different-identity) with the compare/normalize code cited.

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

Missing or inconsistent normalization before security decisions, or byte-vs-character length confusion.

## Impact

Account impersonation/confusion, username squatting, filter bypass, log forgery via bidi.

## Remediation

Normalize to NFC at the boundary, use NFKC where compatibility matters, reject control characters when not needed, measure length in code points.

## Regression Test

Tests with homoglyph, bidi, overlong, and multi-byte inputs asserting normalization and rejection policy.

## Common False Positives

Confusable characters that cannot be registered or are normalized server-side; directives rendered inert by escaping.

## Related Skills

- encoding-validation.md
- canonicalization.md
- username-validation.md
- data-validation.md

## References

- Unicode TR15 (normalization)
- CWE-177
- CVE-2021-42574 (Trojan Source, bidi)

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
