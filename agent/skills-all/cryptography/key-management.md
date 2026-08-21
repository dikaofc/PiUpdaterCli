# Skill: Key Management

## Purpose

Audit cryptographic key lifecycle: generation, storage, rotation, usage separation, and revocation.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: key management, key rotation, keystore, key separation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory all keys: signing, encryption, HMAC, TLS, cloud, third-party API.
2. Check storage: keystores/vault/env-secrets vs hardcoded/repo/committed.
3. Check key separation: distinct keys for different purposes (sign vs encrypt vs HMAC).
4. Check rotation: process, automation, key versioning, dual-key overlap during rotation.
5. Check revocation/compromise response: can keys be revoked centrally?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A key inventory (purpose, storage, rotation status) cited by config/code; any hardcoded/weak-storage key is a finding.

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

Use known-answer tests (NIST vectors) against local code; verify with unit tests, never with production keys.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Keys in code/config, single-purpose reuse, or no rotation process.

## Impact

Key compromise → data decryption, signature forgery; slow recovery without rotation.

## Remediation

Central secrets manager, per-purpose keys, automated rotation with dual-run windows, least privilege, audit access.

## Regression Test

A startup test failing when keys are not sourced from the manager; rotation runbook tested in staging.

## Common False Positives

Test-only keys; public keys by design (verify trust anchoring elsewhere).

## Related Skills

- secret-management.md
- environment-secret-analysis.md
- cryptographic-usage.md

## References

- NIST SP 800-57
- OWASP Secrets Management Cheat Sheet
- CWE-320 (key management errors)

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
