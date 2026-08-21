# Skill: API Surface Analysis

## Purpose

Audit the API inventory end-to-end: documented vs undocumented endpoints, versioning, auth coverage, and consistency across handlers.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api surface, api inventory, endpoints.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Build the endpoint inventory (method, path, params, auth) from specs and code (see endpoint-discovery).
2. Diff documented vs implemented endpoints; flag undocumented and debug endpoints.
3. Classify endpoints by sensitivity: auth-required, object-scoped, money/PII-touching.
4. Check auth coverage: any endpoint without authentication middleware or with implicit bypass (OPTIONS, HEAD, alternate methods).
5. Verify consistent error conventions and versioning strategy.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The full endpoint inventory with auth and sensitivity columns and the diff against specs, cited by handler files.

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

Use a local API with seeded mock data and a scratch test user/tenant; assert with integration tests, not against production.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

N/A — discovery; feeds per-endpoint skills.

## Impact

Hidden endpoints = unauthenticated access, data exposure, and bypass of review.

## Remediation

Centralized route registry, spec-as-code generation, enforcement of auth via middleware defaults.

## Regression Test

A registry diff test failing when undocumented/unauthenticated routes appear.

## Common False Positives

Health/metrics endpoints documented as public; frontend-only routes not served by the API.

## Related Skills

- endpoint-discovery.md
- api-authentication.md
- api-authorization.md
- api-versioning.md

## References

- OWASP API Security Top 10
- CWE-1007

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
