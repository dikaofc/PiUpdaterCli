# Skill: Try/Catch Security

## Purpose

Find security-relevant logic inside try blocks whose failure mode is insecure (fail-open auth, validation skipped on exception).

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: try catch, fail open, exception bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Locate try blocks wrapping auth, token verification, parsing, or validation.
2. Check the catch behavior: falls through to allow access? returns error at wrong boundary?
3. Check the try body completeness: is the critical check actually inside the try (and the fallthrough outside)?
4. Check the same pattern across languages: assertions disabled, exceptions converted to defaults.
5. Test locally: craft input that throws inside a security check and observe acceptance.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local input-triggered exception that bypasses a check (e.g., malformed token accepted), with the try/catch cited.

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

Trigger error paths in tests by feeding malformed input or mocking failures; assert that no sensitive data appears in output.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Sensitive checks inside error-prone blocks with permissive catch fallthrough.

## Impact

Authentication/validation bypass on malformed input.

## Remediation

Move security checks out of error-prone code or fail closed explicitly; fuzz malformed inputs.

## Regression Test

Fuzz/variant tests asserting malformed inputs are rejected.

## Common False Positives

Catch blocks that explicitly return denial; exceptions unreachable from attacker input.

## Related Skills

- error-handling-analysis.md
- fail-open-analysis.md
- deserialization-analysis.md

## References

- OWASP Error Handling
- CWE-703

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
