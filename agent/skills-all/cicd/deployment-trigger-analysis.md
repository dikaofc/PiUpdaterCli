# Skill: Deployment Trigger Analysis

## Purpose

Audit deployment triggers: who/what can trigger prod deployments and what gates exist.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: deployment trigger, prod deploy, approval gate.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find deploy triggers: manual, on-merge, on-tag, scheduled, webhook-triggered.
2. Check approvals: prod deploys require review/approval gates?
3. Check branch sources: deploys from protected branches only?
4. Check webhook triggers: unauthenticated/forged webhooks trigger deploys?
5. Check rollback paths: automated rollback available of equal security.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Trigger config cited (workflow/infra) with gate evidence; unauthenticated deploy trigger is a finding.

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

Audit pipeline definitions in the repository; test in a sandbox CI run with dummy secrets.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Automated deploys without approval or from unvetted sources.

## Impact

Compromised merge → instant production compromise; rogue deploys.

## Remediation

Protected-branch deploys, required approvals/environments, authenticated webhooks with secret verification, instant rollback.

## Regression Test

Tests asserting webhook signature verification and approval gates on prod.

## Common False Positives

Single-developer projects with accepted personal-manual deploy flow (documented).

## Related Skills

- ci-cd-security.md
- deployment-config-review.md

## References

- GitHub environments docs
- CWE-306 (missing auth for critical function)

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
