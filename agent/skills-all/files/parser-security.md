# Skill: Parser Security

## Purpose

Audit parsers of untrusted formats (JSON, XML, CSV, YAML, SVG, fonts, images, markdown) for crashes, resource abuse, and logic discrepancies.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: parser security, parser differential, yaml, csv, svg.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory all parsers consuming untrusted data: JSON/XML/YAML/CSV/SVG/image/font/markdown and binary formats.
2. Check resource bounds: depth limits, size limits, alias expansion (billion laughs), regex ReDoS inside parsers.
3. Check parser-library versions against known parser CVEs (reachability required).
4. Differential-test locally: same payload through parser and downstream consumers; look for discrepancies (extra fields, duplicate keys, number precision).
5. Check parser outputs feeding security decisions (auth, prices, roles).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a parser accepts malformed/hostile input causing a crash, resource spike, or logic discrepancy, with the parser config cited.

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

Unbounded parser configuration (depth/entities/size), outdated parser versions, or parser semantics differing from the validator.

## Impact

DoS, parser-differential security bypasses, injection through smuggled fields.

## Remediation

Configure parser limits (depth, entities), use hardened parsers, pin versions, treat parse results as untrusted, add differential contract tests.

## Regression Test

Tests with hostile parse inputs (billion laughs, deep nesting, duplicate keys, huge numbers) asserting bounded, consistent behavior.

## Common False Positives

Parsers protected by upstream validation (schemas); parser versions without known issues and unreachable attack surface.

## Related Skills

- xml-security.md
- serialization-security.md
- deserialization-analysis.md
- fuzzing-strategy.md

## References

- OWASP XML Security
- CWE-611
- CWE-502

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
