# Skill: Memory Safety Analysis

## Purpose

Audit for memory-safety issues in managed and native code: unsafe constructs, resource lifetime, and unchecked arithmetic.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: memory safety, buffer overflow, use after free, integer overflow.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Locate memory-sensitive code: native modules, unsafe blocks, manual buffers.
2. Check allocation arithmetic and length handling (see binary-parsing-security).
3. Check resource lifetimes: use-after-free, double-free, dangling references.
4. Run static analysis and sanitizers on the codebase where possible.
5. Check drop/finalize logic in managed wrappers around native resources.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Static analysis/sanitizer output or a code audit citing a concrete unsafe pattern.

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

Use sanitizers (ASan/Valgrind), load tests against local services, and bounded resource limits to reproduce exhaustion.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Unsafe memory patterns or unchecked bounds in reachable code.

## Impact

Corruption, RCE, crashes.

## Remediation

Prefer safe abstractions, validate bounds, sanitizer runs in CI, minimize unsafe surface.

## Regression Test

Sanitizer-clean CI runs and fuzz regression tests.

## Common False Positives

Memory-safe language code (Rust safe, GC languages) with no unsafe escapes; unreachable native code.

## Related Skills

- binary-parsing-security.md
- native-code-review.md
- resource-leak-analysis.md

## References

- CWE-787
- CWE-416 (use after free)

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
