# Skill: Password Storage

## Purpose

Verify passwords are stored with appropriate adaptive hashing (Argon2id/bcrypt/scrypt), not reversible or weak hashes.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: password hash, bcrypt, argon2, scrypt, salt.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find credential storage: DB columns, cache, LDAP, SSO stores.
2. Check the hash algorithm and parameters: Argon2id/bcrypt/scrypt with adequate cost, unique per-user salt.
3. Look for weak storage: plaintext, reversible encryption, MD5/SHA1, unsalted sha256, double-hash tricks.
4. Check migration/hybrid schemes (legacy hashes upgrade paths) and timing-safe comparison.
5. Check what reaches logs, backups, or the client (hash exposure).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The storage code with algorithm/cost cited; a local test demonstrating the scheme is reversible or weak (never with real credentials).

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

Test flows against a local auth service with disposable accounts; never brute-force real accounts.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Legacy or convenience hashing without adaptive cost, or reversible encryption of credentials.

## Impact

Password database compromise → mass credential theft (credential stuffing across services).

## Remediation

Argon2id (or bcrypt cost>=12/scrypt), unique salts, constant-time comparison, retirement of legacy weak hashes with rehash-on-login.

## Regression Test

Tests asserting stored values are non-reversible, salted, and use the configured algorithm/cost.

## Common False Positives

Hash-and-HMAC or pepper schemes that are still one-way; values that are encrypted PII (not passwords); test fixtures with weak hashes.

## Related Skills

- password-policy.md
- hardcoded-secret-detection.md
- cryptographic-usage.md
- database-access-control.md

## References

- OWASP Password Storage Cheat Sheet
- NIST SP 800-63B
- CWE-916 (insufficient hash strength)

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
