# Skill: API Idempotency

## Purpose

Audit idempotency of state-changing endpoints: duplicate submissions causing double charges, duplicate orders, or inconsistent state.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: idempotency, duplicate request, retry safety.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Identify non-idempotent operations: payments, orders, refunds, transfers, account changes, notifications.
2. Check idempotency keys: client-supplied key stored server-side and enforced atomically?
3. Test locally: submit the same request twice concurrently/sequentially and observe state (duplicate rows/charges).
4. Check retry behavior of clients and webhook redelivery paths against these endpoints.
5. Verify partial-failure handling: what happens if the first attempt succeeded but the client retries?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local concurrent/duplicate submission test producing duplicate side effects, with the handler and any key-check code cited.

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

No server-side idempotency enforcement, or enforcement via a non-atomic check (race).

## Impact

Double charges, duplicate orders, inconsistent balances, resource waste.

## Remediation

Require idempotency keys for client-initiated mutations, enforce uniqueness atomically (unique constraint), return the stored first result.

## Regression Test

Concurrent duplication tests asserting exactly one side effect.

## Common False Positives

Endpoints that are naturally idempotent (PUT with full state); payment providers already handling idempotency keys.

## Related Skills

- duplicate-request-analysis.md
- duplicate-operation.md
- transaction-analysis.md
- transaction-integrity.md

## References

- Stripe idempotency docs (pattern)
- CWE-799 (uncontrolled interaction frequency)
- OWASP API Security Top 10

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
