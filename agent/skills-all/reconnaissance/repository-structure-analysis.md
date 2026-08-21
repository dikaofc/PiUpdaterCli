# Skill: Repository Structure Analysis

## Purpose

Understand repo organization, ownership boundaries, build system, and where security-relevant code lives before reviewing.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: repo layout, structure, monorepo, boundaries.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Read root manifests (workspace files, go.mod, pyproject.toml, Cargo.toml, *.csproj, package.json) to identify packages and version constraints.
2. Identify the default branch, protected branches, and contribution workflow.
3. Map which directories are deployed vs. tooling-only (scripts, CI).
4. Find internal boundaries: modules that must not import each other, and tenant/user scoping units.
5. Locate configuration, IaC, and documentation describing intended behavior.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A structural map with file references for each unit and its deployment status (deployed/tooling/test).

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

N/A — orientation skill; enables later root-cause tracing.

## Impact

Misreading the structure causes findings to be attributed to the wrong component, wasting effort.

## Remediation

Document module boundaries; enforce with lint/import rules where feasible.

## Regression Test

CI import-boundary lint failing when a prohibited cross-module import is added.

## Common False Positives

Treating all directories as production code; missing hidden modules via vendored/embedded code.

## Related Skills

- project-surface-mapping.md
- dependency-discovery.md
- configuration-discovery.md

## References

- Google "Testing on the Toilet" module boundaries
- CWE-710 (improper adherence to coding standards)

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
