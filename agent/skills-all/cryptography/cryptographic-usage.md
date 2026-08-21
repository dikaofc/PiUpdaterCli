# Skill: Cryptographic Usage

## Purpose

Audit crypto usage: algorithm and mode choices, key lengths, padding, IV/nonce handling, and obsolete algorithms.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: crypto, aes, chacha, rsa, ecdsa, padding, iv nonce.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory cryptography: encryption, signing, hashing, KDFs, key exchange — and the libraries used.
2. Check algorithm/mode: AES-GCM/ChaCha20 preferred; ECB/CBC-without-HMAC, DES/3DES, RC4, MD5/SHA1 (for signatures) flagged.
3. Check key lengths: RSA>=2048, ECC>=256, AES>=128.
4. Check IV/nonce handling: random per encryption, no reuse with the same key (GCM nonce reuse is fatal).
5. Check padding/AA: AEAD used or encrypt-then-MAC; padding-oracle exposure (CBC) avoided.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The crypto code cited (algorithm, mode, IV source) plus any local test demonstrating nonce/IV reuse or weak parameters.

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

Obsolete algorithms or misused modes (nonce reuse, missing AEAD) from legacy code or convenience.

## Impact

Confidentiality/integrity failure: plaintext recovery, forgery, decryption oracles.

## Remediation

Use AEAD (AES-GCM) or libsodium-style APIs, random unique nonces, minimum key sizes, retire legacy algorithms with migration.

## Regression Test

Known-answer tests (NIST vectors) and nonce-uniqueness tests per encryption path.

## Common False Positives

Algorithms used only for integrity (fast hashing with signatures); nonces guaranteed unique by construction (counter with persisted state).

## Related Skills

- weak-hash-analysis.md
- randomness-analysis.md
- key-management.md
- token-generation.md

## References

- NIST SP 800-38A/38D
- OWASP Cryptographic Storage Cheat Sheet
- CWE-327 (broken crypto algorithm)

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
