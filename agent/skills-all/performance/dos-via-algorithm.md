# Skill: Algorithmic DoS

## Purpose

Find algorithmic complexity attacks: regex backtracking, quadratic string ops, hash collisions, and O(n²) loops on input size.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dos, algorithmic complexity, regex, hash collision, quadratic.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find expensive operations on input: regexes, string concat loops, sorts with attacker-controlled comparators, nested loops over request data.
2. Check regex for catastrophic backtracking (nested quantifiers, overlapping alternatives).
3. Check hash table keying: attacker-controlled keys colliding (Java/Django disabled keys before hardening).
4. Check list operations: repeatedly building strings in loops, O(n²) without bounds.
5. Test locally: measure latency response across input sizes for the worst path.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local scaling measurement (e.g., 1.5k vs 10k input latency) showing super-linear growth along the vulnerable path.

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

Benchmark locally with controlled load generators and profile tools; never DoS external services.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Unbounded input processed with super-linear algorithms.

## Impact

CPU-exhaustion DoS with modest request sizes.

## Remediation

Input size limits, safe regex (atomic groups/possessive), keyed/random-seed hash maps, linear algorithms, ReDoS tests.

## Regression Test

Scaling tests asserting sub-quadratic behavior and input limits.

## Common False Positives

Inputs inherently bounded by the protocol; operations on server-owned (not attacker-sized) data.

## Related Skills

- regex-analysis.md
- request-size-limits.md
- fuzzing.md

## References

- OWASP ReDoS
- CWE-1333 (regex catastrophic backtracking)
- CWE-400

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
