# Skill: Stored XSS

## Purpose

Find stored XSS: attacker-controlled data persisted (DB, files, profile fields, comments, names) and rendered later to other users.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: stored xss, persistent xss, stored data rendering.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map persistence sinks (DB writes, file writes, message stores) with attacker-controllable content.
2. Trace the read path: where persisted values are rendered (admin panels, user profiles, lists, exports, emails).
3. Check validation at write time (input sanitization) and encoding at read/rendering time independently.
4. Test the full loop locally: write a benign marker value, re-read and render, inspect output HTML.
5. Check secondary channels: emails, PDFs, CSV exports, log viewers rendering stored data.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local end-to-end test showing a stored value is rendered as markup for another user, citing both write and render lines.

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

Rendering persisted untrusted data without output encoding, or storing markup that the renderer executes.

## Impact

Mass account compromise (admin sessions especially), worms, data theft.

## Remediation

Encode at every render point; sanitize rich-content fields with a maintained library; set CSP; encode at write time for non-rich fields.

## Regression Test

A persistence-render round-trip test with a payload asserted safe in the rendered output.

## Common False Positives

Data encoded at read time; fields only the owner can set with no cross-user rendering; sanitized rich-text pipelines.

## Related Skills

- xss-analysis.md
- unsafe-rendering.md
- frontend-data-exposure.md

## References

- OWASP XSS (stored)
- CWE-79

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
