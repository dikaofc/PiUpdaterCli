# Skill: Build Pipeline Security

## Purpose

Audit the build stage: reproducible builds, dependency resolution integrity, and build script trust.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: build pipeline, reproducibility, build script, dependency resolution.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inspect build scripts and steps: what is fetched/executed at build time.
2. Check reproducibility: lockfiles, pinned toolchains, deterministic output.
3. Check dependency resolution: integrity hashes, registry trust (see dependency-integrity).
4. Check build isolation: fresh environments, no shared mutable caches holding secrets.
5. Check build outputs: artifacts contain no secrets/leftovers.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A build-flow review with lockfile/integrity and artifact-inspection evidence.

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

Non-reproducible builds with dynamic fetches.

## Impact

Poisoned builds distributed to production.

## Remediation

Locked reproducible builds, verified fetches, isolated build envs, artifact hygiene checks.

## Regression Test

CI reproducing builds from scratch and diffing outputs.

## Common False Positives

Toolchains with inherent non-determinism accepted with SBOM+sign verification.

## Related Skills

- dependency-integrity.md
- ci-cd-security.md
- software-supply-chain.md

## References

- SLSA
- CWE-494

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
