# Skill: Approval Workflow

## Purpose

Audit approval flows: approver authorization, self-approval prevention, escalation, and audit.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: approval workflow, self approval, approver bypass.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the approval flow: requester → approver → execution, and its states.
2. Check approver selection: from server data, can a requester choose themselves or an accomplice?
3. Check self-approval: is requester==approver rejected?
4. Check escalation/skip paths: manager-override, delegate, emergency approval — each guarded?
5. Check audit: approvals logged with actor/action/timestamp, tamper-evident.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test attempting self-approval or approver manipulation, with the approval code cited.

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

Understand the intended rule from specs/tests first, then demonstrate violations with a local flow and scripted requests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Approver identity derived from request or missing requester!=approver check.

## Impact

Unauthorized spending/access approved by attackers themselves.

## Remediation

Server-derived approver rules, explicit self-approval denial, escalation with logs, approval audit trail.

## Regression Test

Tests asserting self-approval rejected, approver changes denied, and audit entries present.

## Common False Positives

Approval optional by policy; break-glass documented and audited.

## Related Skills

- business-rule-analysis.md
- workflow-state-analysis.md
- audit-logging.md

## References

- OWASP Business Logic
- CWE-840

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
