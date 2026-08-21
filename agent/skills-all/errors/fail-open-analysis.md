# Skill: Fail-Open Analysis

## Purpose

Find fail-open behavior: security checks that default to allow on error, timeout, or missing configuration.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: fail open, fail closed, default allow.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory security gates: auth, ACL, rate limit, WAF, signature verification.
2. Check failure modes: on exception/timeout/missing config, do they deny or allow?
3. Check circuit breakers around security services (rate limiter down → unlimited?).
4. Check feature flags disabling checks by default.
5. Test locally: simulate the failure (kill the service, remove config) and observe gate behavior.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local simulation showing a security gate defaulting to allow when its dependency or config fails.

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

Defensive-code defaults that treat errors as "not our problem" in security decisions.

## Impact

Auth/rate-limit/bypass under failure conditions.

## Remediation

Fail-closed defaults for security decisions, circuit breakers that deny, config validation at boot.

## Regression Test

Failure-injection tests asserting gates deny on dependency failure.

## Common False Positives

Fail-open by explicit product decision for availability (documented trade-off) in non-security gates.

## Related Skills

- try-catch-security.md
- error-handling-analysis.md
- circuit-breaker-analysis.md

## References

- OWASP Error Handling
- CWE-636 (not failing closed)

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
