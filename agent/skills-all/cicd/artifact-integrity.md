# Skill: Artifact Integrity

## Purpose

Audit artifact lifecycle: signing, verification at deployment, SBOM, and provenance.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: artifact, signature, sbom, provenance.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find artifact types: container images, binaries, packages, bundles.
2. Check signing: artifacts signed at build (cosign) and keys protected.
3. Check verification: deploy pipeline verifies signatures before use.
4. Check SBOM: generated, attached, consumed for vulnerability tracking.
5. Check provenance: attestations of build inputs (SLSA provenance).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Signing/verification config and SBOM presence cited; unverified artifact deployment is a finding.

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

Audit pipeline definitions in the repository; test in a sandbox CI run with dummy secrets.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Artifacts pulled and deployed without integrity verification.

## Impact

Tampered artifact deployment (supply-chain compromise).

## Remediation

Sign at build, verify at deploy, generate/attach SBOM, record provenance.

## Regression Test

CI failing on unsigned artifacts.

## Common False Positives

Internal-only artifacts with equally controlled registries and verified hashes.

## Related Skills

- software-supply-chain.md
- build-pipeline-security.md
- container-image-analysis.md

## References

- SLSA
- sigstore/cosign
- CWE-345 (insufficient verification)

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
