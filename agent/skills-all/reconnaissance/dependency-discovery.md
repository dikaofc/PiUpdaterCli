# Skill: Dependency Discovery

## Purpose

Inventory direct and transitive dependencies, their versions, and where each is actually used.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dependencies, packages, manifest, lockfile.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Read the canonical manifest + lockfile (package-lock.json, poetry.lock, Cargo.lock, go.sum, Gemfile.lock, yarn.lock, requirements.txt + hashes).
2. Diff manifest vs lockfile to detect version drift or uncommitted dependency changes.
3. Resolve the full transitive tree and note duplicated versions (diamond dependencies).
4. Cross-check dependencies against advisories (OSV/npm audit/pip-audit/cargo-audit) as a trigger only, never proof of exploitability.
5. Record where each dependency is imported/used (import graph) for later reachability analysis.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A dependency table: package, version, direct/transitive, security-relevant usage sites, advisory status (reachability pending).

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

Use only repositories/projects you own or have written authorization to inspect. Run discovery against local clones and localhost services; never against third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

N/A — discovery; feeds dependency-audit & supply-chain skills.

## Impact

Unknown/undocumented dependencies expand the attack surface invisibly.

## Remediation

Pin versions, use lockfiles, and automate dependency scanning in CI.

## Regression Test

CI failing when a new dependency lacks an approved entry in an allowlist/SBOM.

## Common False Positives

Reporting a CVE without checking whether the vulnerable code path is used (see dependency-audit).

## Related Skills

- dependency-audit.md
- transitive-dependencies.md
- supply-chain-risk.md
- lockfile-analysis.md

## References

- OWASP Dependency-Check docs
- NIST SP 800-218 (SSDF)

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
