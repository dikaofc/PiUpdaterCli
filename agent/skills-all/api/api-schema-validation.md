# Skill: API Schema Validation

## Purpose

Ensure API request bodies match documented schemas with strict validation, preventing extra/wrong-type fields from reaching business logic.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: api schema, request validation, additional fields.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check OpenAPI/JSON-schema enforcement: is a validator applied to every endpoint's body?
2. Look for permissive schemas (additionalProperties:true, untyped fields) allowing hidden fields.
3. Test locally: send extra fields (is_admin, price, owner_id), wrong types, duplicate keys; verify rejection or documented acceptance.
4. Check content-type handling (form vs JSON vs XML) for validation-application gaps.
5. Verify array/object deep validation (nested fields validated too).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A request that bypasses schema constraints and changes behavior/persistence, or proof some endpoints lack validation entirely.

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

Schema not wired to all routes, or schemas too permissive vs the data model.

## Impact

Mass assignment, business-logic tampering, inconsistent data, parser differentials.

## Remediation

Enforce schemas centrally (middleware), set additionalProperties:false, share schemas, add contract fuzz tests.

## Regression Test

Contract tests feeding extra/nested/wrong-type fields asserting rejection.

## Common False Positives

Routes intentionally accepting free-form payloads (webhooks) — validated separately.

## Related Skills

- schema-validation.md
- mass-assignment.md
- api-input-boundaries.md
- type-confusion.md

## References

- OWASP API Security Top 10
- CWE-20
- OpenAPI spec

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
