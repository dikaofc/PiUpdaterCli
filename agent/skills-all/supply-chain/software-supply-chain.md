# Skill: Software Supply Chain

## Purpose

Audit the full supply chain: build, publish, distribution, and consume paths of the software.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: supply chain, build poisoning, publishing, distribution.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map the chain: source → CI → build artifacts → registry/package → deployment.
2. Check each hop for compromise points: build scripts fetching unverifiable code, unauthenticated build triggers.
3. Check publish paths: who can publish releases, MFA on package registries?
4. Check distribution: artifacts signed, SBOM produced and verified at deploy?
5. Check third-party scripts in the app (executables in repo, macros, postinstall hooks).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A chain diagram with trust boundaries and evidence per hop (signed artifacts, MFA, SBOM).

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

Compare package integrity and provenance records offline; verify hashes from the official registry metadata.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Untrusted code execution at any hop (postinstall scripts, unauthenticated CI triggers).

## Impact

Backdoored builds distributed to all users.

## Remediation

Pin + verify every fetched artifact, MFA for publish, signed releases, SBOM + verify at deploy, minimal postinstall hooks.

## Regression Test

CI asserting artifact signatures and SBOM matches before release.

## Common False Positives

Fully internal toolchains with controlled registries and signed every hop.

## Related Skills

- dependency-integrity.md
- ci-cd-security.md
- build-pipeline-security.md

## References

- OWASP Supply Chain Security
- SLSA framework
- CWE-1357

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
