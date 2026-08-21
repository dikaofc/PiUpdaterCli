# Skill: Security Test Planning

## Purpose

Plan a structured security audit: scope, assets, threat model, test matrix, and evidence logging.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: test plan, security audit, scope, threat model.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Define scope: in-scope assets, endpoints, roles, and out-of-scope (legal/sandbox notes).
2. Build a threat model summary: key assets and trust boundaries.
3. Create a test matrix: skill × endpoint × role × expected result.
4. Define the evidence format: request/response pairs, code citations, severity.
5. Define safe test setup: disposable accounts, staging data, no production impact.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A written test plan + matrix tracking each test, its status, and linked evidence.

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

All testing happens in local test suites; no live target required.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Ad-hoc testing misses paths and produces unverifiable claims.

## Impact

Gaps in coverage; findings that cannot be reproduced or triaged.

## Remediation

Use the skill library to drive the matrix; evidence-backed findings; severity guidance.

## Regression Test

Re-audit runs replaying the matrix.

## Common False Positives

Plans that over-scope; avoid testing code explicitly out of scope.

## Related Skills

- threat-modeling.md
- reporting-and-triage.md
- audit-trail-maintenance.md

## References

- OWASP Testing Guide
- PTES

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
