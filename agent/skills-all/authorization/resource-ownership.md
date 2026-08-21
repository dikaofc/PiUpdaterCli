# Skill: Resource Ownership

## Purpose

Audit ownership semantics: how resources map to owners, transfer of ownership, and ownership re-derivation.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: resource ownership, owner field, transfer.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Define ownership for each resource type (user, tenant, org, session-scoped).
2. Check where owner_ids come from (server-derived) and how they are stored.
3. Check ownership changes: transfer flows require authorization and re-scope containers (files, sessions).
4. Check orphaned/migrated resources after owner deletion transfer.
5. Test locally: transfer ownership and verify old owner loses access, new owner gains it.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Ownership model cited with a transfer test verifying both sides.

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

Create two or more test users/tenants in a local environment and write integration tests asserting denied access.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Ownership fields settable by clients or not re-derived on transfer.

## Impact

Access persistence after transfer/deletion, unauthorized takeover.

## Remediation

Server-managed ownership, authorize transfers, cascade/re-scope children on transfer, purge on deletion.

## Regression Test

Transfer tests asserting both old/new owner access states.

## Common False Positives

Resources keyed by immutable IDs where "ownership" is documentary only.

## Related Skills

- resource-ownership.md
- idor-analysis.md
- server-side-authorization.md

## References

- OWASP Authorization Cheat Sheet
- CWE-862

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
