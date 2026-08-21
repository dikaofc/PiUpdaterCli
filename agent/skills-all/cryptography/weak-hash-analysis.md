# Skill: Weak Hash Analysis

## Purpose

Find weak hash usage: MD5/SHA1 for security-critical purposes (signatures, integrity, password storage) and missing keyed-hash construction.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: weak hash, md5, sha1, hmac, collision.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find hash usage: integrity checks, signatures, password storage, dedup, ETags, caches.
2. Classify by purpose: password storage (see password-storage), signatures (collision/extension risk), integrity (HMAC needed).
3. Check keyed vs unkeyed: HMAC for integrity; raw hash of secret+data vulnerable to length extension.
4. Check whether hash output is used in trust decisions (filename, IDs from hashes).
5. Test locally: demonstrate hash-collision awareness for the specific usage (evidence-based: no live exploitation).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The hash call site with purpose cited; a local test showing advisory-level collision relevance (e.g., SHA-1) or length-extension suitability.

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

Legacy hash algorithms kept for security purposes or unkeyed hashing of secret data.

## Impact

Forgery (signature collisions), integrity bypass, password cracking (fast hashes).

## Remediation

Switch to SHA-256/3 for digests with HMAC for integrity, Argon2/bcrypt for passwords, document hash versioning for compatibility.

## Regression Test

Tests asserting security-critical hashes use approved algorithms with HMAC.

## Common False Positives

Hashing for dedup/non-security purposes; collision-resistant usage (preimage beyond practical) for public data.

## Related Skills

- cryptographic-usage.md
- password-storage.md
- token-generation.md

## References

- NIST SP 800-107
- CWE-328 (weak hash)
- CWE-916

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
