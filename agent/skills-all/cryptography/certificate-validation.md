# Skill: Certificate Validation

## Purpose

Audit where certificates are validated (clients, SDKs, curl): disabled verification, custom accept-any logic, and broken chain checks.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: certificate validation, ssl verify, bypass, accept any.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find TLS verification points: HTTP clients, DB/MQ clients, SDKs, webhooks, mobile apps.
2. Search for verification disablement: verify=false, ssl_verify=False, NODE_TLS_REJECT_UNAUTHORIZED, insecure curl, custom trust-all.
3. Check custom certificate handling: pinned certs used correctly, hostname verification not skipped.
4. Check mutual TLS usage where required (service-to-service).
5. Test locally: connect to a self-signed/local test server and observe whether the client rejects it.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A local test showing a client accepts an invalid certificate (or verification-disabled config cited).

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

Trust-all shortcuts in client code or config disabling verification.

## Impact

MITM of app traffic, credential interception.

## Remediation

Never disable verification; use system trust stores or explicit pins, verify hostnames, keep CA bundles updated.

## Regression Test

Tests asserting clients reject invalid/hostname-mismatched certificates; CI check banning verify=false.

## Common False Positives

Test/dev configs only; verified pins for private CA setups.

## Related Skills

- tls-configuration.md
- network-exposure.md
- mobile-ssl-pinning.md

## References

- OWASP Transport Layer Protection
- CWE-295 (improper certificate validation)

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
