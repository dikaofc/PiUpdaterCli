# Skill: Query Safety

## Purpose

Audit query construction across SQL and ORM boundaries: parameterization, identifiers, and dynamic fragments.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: query safety, parameterized query, dynamic query, order by injection.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find every query site: raw SQL, query builders, ORM, stored procedures, database functions.
2. Check parameterization of all values (placeholders for values).
3. Check identifier injection: column names, order-by fields, table prefixes built from input.
4. Check dynamic WHERE building with user-driven filters (blind spots in ORM APIs).
5. Check query error behavior (does a bad query leak details or crash the request?).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A query inventory with parameterization status per site; a local test showing identifier-level injection or unparameterized interpolation.

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

Reproduce query/transaction behavior against a local test database with transaction rollbacks; use synthetic data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

String interpolation of identifiers/fragments or ORM misuse (raw APIs) in hot paths.

## Impact

SQL injection, data exposure, DoS via bad queries.

## Remediation

Parameterize all values, allowlist identifiers, use ORM query builders consistently, add a lint/static rule against string-built SQL.

## Regression Test

Tests asserting quote/comment payloads are inert in every query site.

## Common False Positives

Identifier inputs validated against a strict allowlist; ORM usage with bound parameters.

## Related Skills

- sql-injection.md
- orm-security.md
- database-error-leakage.md

## References

- OWASP SQL Injection Prevention
- CWE-89

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
