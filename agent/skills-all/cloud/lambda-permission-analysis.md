# Skill: Lambda Permission Analysis

## Purpose

Audit serverless function triggers/permissions: who can invoke, what the function can reach, and cross-account exposure.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: lambda permissions, invoke permissions, resource policy.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Review function resource policies: allowed invoke principals, conditions.
2. Check execution roles: least privilege for the function's needs.
3. Check triggers: unauthenticated invocation (public HTTP/API endpoints), event source policies.
4. Check cross-account: functions shared with untrusted accounts.
5. Check internal workflows calling functions with elevated roles.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A trigger/role review with any over-permissive invoke policy or role cited.

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

Use cloud provider policy simulators and read-only IAM policy evaluation on your own account only.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Default-wide invoke policies or generous execution roles.

## Impact

Unauthorized invocation → cost abuse, data access via function role.

## Remediation

Source-conditioned invokes, minimal execution roles, monitor invocation patterns.

## Regression Test

Policy assertions on invoke conditions and role scope.

## Common False Positives

Intentional public APIs with safe handlers.

## Related Skills

- serverless-security.md
- cloud-iam-analysis.md
- api-authentication.md

## References

- AWS Lambda permissions docs
- CWE-732

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
