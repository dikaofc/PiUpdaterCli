# Skill: Dependency Failure Handling

## Purpose

Audit handling when external dependencies fail: graceful degradation vs cascading failures and fail-open risks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dependency failure, degradation, cascade, fail open.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map external dependencies: auth, payments, email, storage, third-party APIs.
2. Check failure modes: timeouts, retries, error propagation.
3. Check degradation: does the app still function safely when a dependency is down?
4. Check fail-open: auth/payment failures defaulting to allow?
5. Check cascade: one dependency outage taking down unrelated features.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A dependency-failure test showing fail-open behavior or cascade, with the handler cited.

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

Use fault-injection tests (chaos-style, local) that simulate partial failures; assert graceful degradation in tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Dependencies treated as always-available with fail-open defaults.

## Impact

Auth bypass during outages, cascade outages, degraded security posture.

## Remediation

Fail-closed for security-critical deps, circuit breakers with isolation, graceful degradation per feature, define acceptable degraded modes.

## Regression Test

Fault-injection tests per dependency asserting the intended degraded behavior.

## Common False Positives

Dependencies with health-checked redundancy; documented degraded modes.

## Related Skills

- fail-open-analysis.md
- reliability-failure-analysis.md
- circuit-breaker-analysis.md

## References

- OWASP Error Handling
- CWE-636

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
