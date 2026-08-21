# Skill: Dependency Analysis

## Purpose

Audit dependencies: known vulnerable versions, outdated packages, and unmaintained libraries.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: dependency, vulnerable version, outdated, cve.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory dependencies (package.json, requirements, go.mod, gems, cargo): pinned versions, lockfiles.
2. Check against vulnerability databases (OSV, NVD, GitHub Advisory) for known CVEs.
3. Check update lag: how far behind latest/major stable?
4. Check unmaintained packages: no recent releases, archived repos.
5. Check version pinning: floating ranges allowing unexpected upgrades.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A dependency report with (package, version, advisory status) plus a local audit tool output (npm audit/osv-scanner).

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

Neglected dependency hygiene and untracked upgrades.

## Impact

Known-CVE exploitation (RCE, SQLi in libraries), supply-chain surprises.

## Remediation

Lockfiles committed, update automation with CI gates, drop unmaintained deps, monitor advisories, minimize footprint.

## Regression Test

CI failing on new vulnerabilities (osv-scanner/npm audit) and lockfile drift.

## Common False Positives

Dev-only dependencies with no prod reach; advisories fixed in newer-but-unpinned ranges.

## Related Skills

- dependency-integrity.md
- software-supply-chain.md
- update-verification.md

## References

- OWASP Dependency Check
- OSV database
- CWE-1104

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
