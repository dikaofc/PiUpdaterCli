# Skill: Dependency Integrity

## Purpose

Audit dependency integrity: integrity hashes, signed artifacts, registry source, and lockfile immutability.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dependency integrity, lockfile, integrity hash, registry.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Check lockfiles: committed, integrity hashes (npm shasum, go.sum, cargo checksum) verified.
2. Check registry source: official registries only, no unknown scopes/mirrors in prod.
3. Check custom/git dependencies: pinned to commit hashes, not mutable branches.
4. Check build reproducibility: same inputs → same artifacts (lockfile-driven installs).
5. Check proxy behavior: registry caching (verdaccio) validating upstream integrity.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Lockfile and registry config cited; any mutable ref (branch dep) or missing hash is a finding.

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

Run audits against lockfiles/package manifests locally; validate reachability in a local build before reporting.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Install from floating branches or registries without integrity verification.

## Impact

Compromised/mutated dependency injection into builds.

## Remediation

Commit lockfiles with hashes, pin git deps to commits, restrict registry scopes, verify signatures.

## Regression Test

CI comparing lockfile hash state and failing on floating refs.

## Common False Positives

Internal registries with private packages (integrity managed by the platform).

## Related Skills

- dependency-analysis.md
- software-supply-chain.md
- build-pipeline-security.md

## References

- CWE-494 (download of code without integrity check)
- npm/Go lockfile docs

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
