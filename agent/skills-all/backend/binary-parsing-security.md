# Skill: Binary Parsing Security

## Purpose

Audit binary/protocol parsers: length handling, integer overflow, and malformed input robustness.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: binary parsing, integer overflow, length prefix, malformed.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find binary parsers: length-prefixed formats, custom protocols, image/audio decoders.
2. Check length fields: validated against bounds before allocations?
3. Check integer arithmetic: overflow on size computations (a+b, count*size).
4. Check slicing: negative or huge offsets.
5. Fuzz locally: mutate lengths/counts and observe crashes/bounds violations.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local fuzz run producing a crash/bounds violation or a code audit proving unchecked arithmetic.

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

Trace code paths locally with debuggers/tests and mock services; reproduce with unit/integration tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Missing bounds/overflow validation in parser arithmetic.

## Impact

Buffer overflow, heap corruption, memory exhaustion, RCE in native code.

## Remediation

Use safe integer arithmetic (checked), validate lengths before use, fuzz with structure-aware corpora, prefer battle-tested parsers.

## Regression Test

Fuzz regression tests pinned to found crashes.

## Common False Positives

Parsers from mature libraries (protobuf, standard decoders) with the app passing already-validated inputs.

## Related Skills

- fuzzing.md
- boundary-validation.md
- memory-safety-analysis.md

## References

- CWE-190 (integer overflow)
- CWE-120 (buffer overflow)

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
