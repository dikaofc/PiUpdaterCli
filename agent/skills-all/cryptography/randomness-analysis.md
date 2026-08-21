# Skill: Randomness Analysis

## Purpose

Audit random number usage: predictable PRNGs (Math.random, rand(), time-seeded) for security tokens, salts, IVs, and IDs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: randomness, prng, crypto random, predictable.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find random value generation: tokens, session IDs, salts, IVs/nonces, password resets, CAPTCHA, shortcodes.
2. Check the source: crypto-secure API (crypto.randomBytes, secrets, SecureRandom, os.urandom, dev/urandom, getrandom) vs predictable (Math.random, rand(), time/millis seeds, LCG).
3. Check seeding: default seeds, time-based, ID-based, weak seeds.
4. Check usage contexts: any security decision based on predictable randomness.
5. Test locally: sample generated values and assess entropy pattern (advisory evidence, e.g., timestamp-derived collisions).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- The generation code cited plus a local entropy sample analysis showing predictability (e.g., sequential/guessable suffix).

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

Convenience PRNG used where unpredictable tokens are required.

## Impact

Token guessing → account takeover, password-reset hijack, session forgery.

## Remediation

Use language crypto-secure RNGs everywhere security-relevant; audit all token/session generation paths.

## Regression Test

Statistical uniqueness tests over many generated values; code-level enforcement (lint banning Math.random for tokens).

## Common False Positives

Non-security randomness (shuffle UI, A/B) harmless; seeds injected for test reproducibility only in test code.

## Related Skills

- token-generation.md
- cryptographic-usage.md
- password-reset.md

## References

- NIST SP 800-90B
- OWASP Cryptographic Storage Cheat Sheet
- CWE-330

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
