# Skill: Error Handling Analysis

## Purpose

Audit error handling: unhandled exceptions, swallowed errors, and error-driven control flow.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: error handling, exception, swallowed error, fail open.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find catch blocks: what happens on exception — rethrow, continue, or fail-open?
2. Check fail-open paths: catch-and-continue around auth/authorization/validation.
3. Check swallowed errors: empty catches that hide failures (attacker can trigger).
4. Check error-as-control-flow: exceptions used for business decisions (parse errors, boundary checks).
5. Check partial-state on errors: writes before the exception persist?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A code path where an exception leads to fail-open or partial state, demonstrated by a local trigger.

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

Catch-and-ignore patterns or error-driven logic in security-sensitive paths.

## Impact

Auth bypass (fail-open), hidden failures, inconsistent data.

## Remediation

Explicit error handling with fail-closed defaults in security paths, log-and-rethrow for recoverable, unit tests for error paths.

## Regression Test

Fault-injection tests asserting fail-closed behavior.

## Common False Positives

Deliberately tolerant error handling in non-critical analytics paths.

## Related Skills

- try-catch-security.md
- sensitive-error-data.md
- fail-open-analysis.md

## References

- OWASP Error Handling
- CWE-703 (improper check/unchecked error)

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
