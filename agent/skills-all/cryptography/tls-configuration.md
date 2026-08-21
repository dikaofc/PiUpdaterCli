# Skill: TLS Configuration

## Purpose

Audit TLS configuration: protocol versions, cipher suites, certificate handling, and TLS termination.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: tls, ssl, hsts, cipher suite, certificate.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find TLS termination: the app server, reverse proxy, CDN, or LB — and its configuration.
2. Check protocol versions: TLS 1.2/1.3 minimum, no SSLv3/TLS1.0/1.1.
3. Check cipher suites: modern AEAD suites, no RC4/DES/weak CBC.
4. Check certificate: valid chain, key size, SANs, and no self-signed in prod.
5. Check HSTS and preloading; redirect all HTTP to HTTPS; no mixed content.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- TLS config cited (from IaC/proxy config or a local TLS scan of a test deployment) with protocol/cipher lists.

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

Default/lazy TLS termination configs allowing weak protocols or ciphers.

## Impact

MITM, traffic decryption, downgrade attacks.

## Remediation

TLS 1.2+ with AEAD suites, HSTS preload, HTTP→HTTPS redirects, certificate automation (Let's Encrypt/Vault).

## Regression Test

CI TLS-config linting and periodic external scans (SSLLabs-style) in staging.

## Common False Positives

Termination at a managed provider with strong defaults; internal-only TLS with documented weaker config.

## Related Skills

- security-headers.md
- certificate-validation.md
- reverse-proxy-analysis.md

## References

- OWASP Transport Layer Protection Cheat Sheet
- NIST SP 800-52
- CWE-326 (weak encryption)

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
