# Skill: Schema Validation

## Purpose

Verify structured inputs (JSON/XML/protobuf/forms) are validated against a schema that matches the real expectation of the code.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: schema, json schema, validation, request body.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find the schema/contract for each structured input (JSON Schema, OpenAPI requestBody, protobuf, pydantic/dataclass models, serializer classes).
2. Check for permissive schemas: additionalProperties:true, unconstrained strings, "any" types, missing required fields.
3. Verify the validation is actually applied (middleware) and not bypassable via alternative content types or duplicate keys.
4. Test schema edge cases: extra fields (mass assignment), wrong types, nested objects, huge arrays, duplicate keys, unknown enum values.
5. Compare model field defaults with server-side enforcement (defaults that enable privileged paths).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The schema file + the middleware that applies it + one sample request that bypasses a constraint; or evidence the schema contradicts the data model.

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

Build local fixtures with a test HTTP server or CLI harness that feeds controlled payloads (valid, boundary, malformed) and assert behavior in unit tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Schema drift: the schema admits more than the code expects, or validation is not wired to the endpoint.

## Impact

Mass assignment, storage of malformed data, parser inconsistencies, auth/amount bypasses.

## Remediation

Strict schemas with additionalProperties:false, shared client/server, enforced in middleware, types validated at the ORM boundary.

## Regression Test

Contract tests feeding extra/wrong-type/duplicate-key payloads, asserting rejection.

## Common False Positives

Validators that exist but are not invoked for that route; frameworks that parse leniently after schema validation (double parsing).

## Related Skills

- untrusted-input-analysis.md
- mass-assignment.md
- api-schema-validation.md
- type-confusion.md

## References

- OWASP API Security Top 10 (schema & API5)
- CWE-20
- CWE-1023

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
