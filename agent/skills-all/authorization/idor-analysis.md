# Skill: IDOR Analysis

## Purpose

Hunt for Insecure Direct Object References: direct use of object identifiers without ownership checks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: idor, direct object reference, object id.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find every endpoint using object IDs from the client (path, query, body).
2. Trace the ownership check between the principal and the object.
3. Test locally with crossed objects (user A reads user B's record).
4. Check indirect references: tokens, hashed IDs, filenames, keys exposed in URLs.
5. Check enumeration: sequential IDs make bulk harvesting trivial.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A crossed-object behavioral test (or the missing check line), with the handler cited.

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

Object fetched by ID alone and returned without verifying the requester's relationship.

## Impact

Mass data disclosure, tampering, deletion of others' resources.

## Remediation

Access objects via scoped queries (combined owner+ID), enforce checks centrally, avoid enumerable identifiers.

## Regression Test

Cross-user tests on every ID-referencing endpoint plus sequential enumeration attempts.

## Common False Positives

Shared/collaborative objects with documented visibility; public listings.

## Related Skills

- bola-analysis.md
- resource-ownership.md
- file-download-security.md

## References

- OWASP IDOR
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
