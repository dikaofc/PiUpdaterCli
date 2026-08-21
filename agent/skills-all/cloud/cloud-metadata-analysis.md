# Skill: Cloud Metadata Analysis

## Purpose

Audit instance metadata service exposure (IMDS): SSRF-to-metadata, IMDSv1 vs v2, and token handling.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: cloud metadata, imds, ssrf, metadata service.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check metadata service version: IMDSv1 (token-less GET) vs IMDSv2 (PUT token).
2. Map SSRF-reachable surfaces that could hit 169.254.169.254 (or GCP 169.254.169.254 / metadata.google.internal).
3. Check credentials from metadata: role credentials scope and expiry.
4. Check allowlists: IMDS hops/network policy restricting metadata access.
5. Test locally (staged): a SSRF sink reaching the metadata endpoint if identified.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- IMDS config (v1 vs v2) and a staged SSRF-metadata reachability test, or the missing SSRF guard cited.

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

Use cloud provider policy simulators and read-only IAM policy evaluation on your own account only.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

IMDSv1 enabled or SSRF protections absent, letting requests reach metadata.

## Impact

Cloud credential theft via one SSRF — full account compromise potential.

## Remediation

Enforce IMDSv2 + hop limit, block metadata IPs at the network layer, prevent SSRF to link-local ranges.

## Regression Test

Tests asserting metadata IPs are blocked by proxies/firewalls and IMDSv2 required.

## Common False Positives

No SSRF surface (no outbound fetches); metadata blocked by network policy.

## Related Skills

- ssrf-analysis.md
- cloud-iam-analysis.md
- network-exposure.md

## References

- AWS hardening IMDS
- GCP metadata docs
- CWE-918

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
