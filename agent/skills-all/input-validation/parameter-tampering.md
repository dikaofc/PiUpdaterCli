# Skill: Parameter Tampering

## Purpose

Check whether client-supplied parameters can change server-side decisions: hidden fields, amounts, IDs, roles, prices, pagination, status.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: parameter tampering, hidden fields, client trust.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List every field the client can submit (forms, query, JSON body, headers) and map it to a server-side decision.
2. Flag fields that should be server-authoritative but are client-supplied: price, role, ownership, status, discount, refund amount.
3. Check whether server re-derives values (from DB/session) or accepts the client value verbatim.
4. Test overriding parameters: duplicate params, extra headers (X-Forwarded-*), array coercion, null in place of numbers.
5. Verify server-side recomputation of totals/limits after applying submitted values.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A client value that changes a security-relevant decision (price, role, owner, status) confirmed by a behavioral test.

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

Trusting client-provided values for decisions that must be server-authoritative.

## Impact

Price manipulation, privilege escalation, ownership bypass, unauthorized state changes.

## Remediation

Re-derive authoritative values server-side; treat all client fields as hints, never as truth.

## Regression Test

Tests submitting tampered prices/roles/IDs/status asserting the server value wins.

## Common False Positives

Fields echoed back to the client but re-derived server-side on the next request.

## Related Skills

- mass-assignment.md
- type-confusion.md
- price-integrity.md
- http-parameter-pollution.md

## References

- OWASP Web Security Testing Guide — Testing for Parameter Tampering
- CWE-472 (external control of assumed-immutable web parameter)

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
