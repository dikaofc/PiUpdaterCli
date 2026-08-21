# Skill: Framework Security

## Purpose

Audit framework usage for security-relevant configurations and misuse of unsafe framework patterns.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: framework security, express, rails, django, unsafe patterns.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify frameworks and their versions (see dependency-analysis for CVEs).
2. Check framework security defaults: CSRF middleware, auto-escaping, ORM parameterization.
3. Check framework-specific unsafe patterns: eval-like template renders, unsafe redirect helpers, mass-assignment helpers.
4. Check framework update posture for security fixes.
5. Check framework docs for the recommended secure configuration vs actual.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A framework config review citing deviations from secure defaults with specific lines.

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

Framework security defaults disabled or unsafe helpers used.

## Impact

Framework-class vulnerabilities (CSRF, XSS, mass assignment) across the app.

## Remediation

Keep frameworks patched, enable security middleware, follow secure-by-default config, ban unsafe helpers.

## Regression Test

CI checks for framework security config; tests for the helpers.

## Common False Positives

Framework defaults intact and verified against the recommended config.

## Related Skills

- dependency-analysis.md
- mass-assignment.md
- csrf-analysis.md

## References

- Framework security docs
- CWE-1188 (insecure default initialization)

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
