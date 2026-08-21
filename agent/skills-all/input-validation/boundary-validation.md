# Skill: Boundary Validation

## Purpose

Test inputs at their defined boundaries (limits, ranges, lengths, allowed sets) and verify rejections are correct and enforced.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: boundary, limits, length, range, allowlist.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find every declared limit: max lengths, max/min values, allowed enums, allowed file types, pagination caps, upload size caps.
2. Identify where limits are enforced: at the boundary, in the model layer, or nowhere.
3. Test limit boundaries with values at, one below, one above, and far above the declared limit.
4. Check what happens on violation: rejection, truncation, wrap-around, or acceptance (silent failure).
5. Verify limits are per-request, per-resource, and per-user where required (not just global caps).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- For each limit: the declared value (from config/code), the enforcement point, and observed behavior at/above the boundary.

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

Limits declared in docs/config but not enforced in code, or enforced only client-side, or enforced with off-by-one errors.

## Impact

Input too large for allocation, pagination abusing limits, quota bypass, database DoS, or storage exhaustion.

## Remediation

Enforce limits server-side at the boundary, return explicit errors (413/422), and centralize limit definitions.

## Regression Test

Boundary tests at limit-1, limit, limit+1 asserting correct accept/reject for every input limit.

## Common False Positives

Limits enforced by an upstream proxy/API gateway counted as absent in the app; truncation that is safe and intentional.

## Related Skills

- untrusted-input-analysis.md
- boundary-testing.md
- rate-limit-analysis.md
- resource-limit-analysis.md

## References

- OWASP Input Validation Cheat Sheet
- CWE-770 (allocation without limits)

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
