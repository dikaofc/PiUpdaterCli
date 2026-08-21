# Skill: Client Storage Review

## Purpose

Audit client-side storage: localStorage/sessionStorage/IndexedDB for sensitive data and token material.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: localstorage, sessionstorage, indexeddb, sensitive data.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory client storage writes: tokens, PII, cart data, preferences.
2. Classify sensitivity: auth material (critical), PII (sensitive), cache (low).
3. Check XSS-readability implications of each store.
4. Check data lifetime: cleanup on logout?
5. Check usage by third-party scripts (analytics reading storage).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A storage inventory with sensitivity classification and logout-cleanup evidence.

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

Inspect bundles locally; run browser automation against a local build. Never exfiltrate data.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Sensitive data placed in XSS-readable, persistent stores.

## Impact

Theft via XSS/extension; stale data leaks on shared devices.

## Remediation

Minimize sensitive client storage, HttpOnly cookies where possible, clear storage on logout, transient caches for low-risk data.

## Regression Test

Tests asserting no auth tokens in storage stores and logout cleanup.

## Common False Positives

Low-sensitivity caches with documented expiry; encrypted-at-rest platform storage APIs.

## Related Skills

- frontend-api-security.md
- local-storage-secrets.md

## References

- OWASP HTML5 Security
- CWE-922

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
