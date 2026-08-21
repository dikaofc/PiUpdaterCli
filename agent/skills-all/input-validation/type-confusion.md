# Skill: Type Confusion

## Purpose

Find places where attacker-controlled type manipulation (string vs number vs object vs array) changes program behavior or bypasses checks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: type confusion, type juggling, comparison bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find comparisons involving user input: weak equality (== in PHP/JS), loose comparisons, type coercion in SQL/NoSQL queries.
2. Look for objects/arrays/booleans arriving from JSON parsers used where code expects a scalar (e.g., array where string expected).
3. Check numeric corner cases: "1e308", Infinity/NaN, big integers, -0, empty string as 0, leading zeros.
4. Find polymorphic fields (or "any"-typed fields) flowing into security decisions (roles, allowed lists, amounts).
5. Verify behavior with local tests: feed {"role":["admin"]}, "9999", true, null through the exact code path.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A concrete input value (type) that produces different security-relevant behavior than intended, with the comparison line cited.

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

Weak typing assumptions in comparisons or missing runtime type checks before security decisions.

## Impact

Auth bypass (["admin"] treated as admin), amount bypass (string vs number), or validation bypass.

## Remediation

Validate types explicitly (typeof/instanceof/schema), use strict equality, reject unexpected types at the boundary.

## Regression Test

Tests supplying objects/arrays/booleans/NaN/Infinity at each comparison, asserting expected rejection.

## Common False Positives

Type manipulation that ultimately fails validation elsewhere; coercions producing identical security outcomes.

## Related Skills

- schema-validation.md
- untrusted-input-analysis.md
- parameter-tampering.md
- mass-assignment.md

## References

- OWASP API Security — mass assignment & types
- CWE-843 (type confusion)
- CWE-697 (insecure comparison)

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
