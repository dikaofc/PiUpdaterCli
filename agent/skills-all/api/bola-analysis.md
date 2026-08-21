# Skill: Broken Object Level Authorization (BOLA)

## Purpose

Hunt for BOLA/IDOR in object-referencing endpoints: clients referencing object IDs not owned by them.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: bola, idor, object level authorization.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List endpoints taking resource IDs (path params, body IDs, query IDs) and resolve the owning user/tenant.
2. Trace whether an ownership check exists before returning/altering the object.
3. Test locally: user A fetches/updates/deletes user B's object ID; assert rejection (and run the reverse).
4. Check enumeration paths: sequential numeric IDs, UUIDs disclosed in responses used to access others' objects.
5. Check indirect objects: invoices, files, messages, carts, sessions owned by the requestor.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A behavioral test where user A accesses user B's object (or the ownership check's code absence), citing the handler.

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

Handler trusts the caller-provided ID without verifying ownership against the authenticated principal.

## Impact

Mass data disclosure (user records, PII), tampering, deletion of others' resources.

## Remediation

Fetch objects by (id, owner) pairs, enforce checks at a single service layer, use opaque IDs, avoid raw ID-based flows.

## Regression Test

Pairwise cross-user tests for every object-referencing endpoint.

## Common False Positives

Objects with intended cross-user visibility (shared resources) — verify the domain rule first.

## Related Skills

- idor-analysis.md
- resource-ownership.md
- horizontal-privilege-escalation.md
- api-authorization.md

## References

- OWASP API Security Top 10 API1
- CWE-639

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
