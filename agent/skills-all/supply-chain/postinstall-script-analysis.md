# Skill: Postinstall Script Analysis

## Purpose

Audit install-time scripts (postinstall, setup.py, Makefile in deps, hooks) for arbitrary code execution.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: postinstall, npm scripts, install hooks, execution.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List install scripts: package postinstall, gems post install, pip setup, git hooks, container RUN instructions.
2. Check legitimacy: what each script downloads/executes at install time.
3. Check network fetches at install time (curl-pipe scripts, fetching binaries).
4. Check privilege: installs run as user/root? Can they touch prod secrets?
5. Check allowlist/review process for new dependencies with install scripts.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- An install-script inventory with network/execution actions; any curl-pipe or dynamic fetch is a finding.

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

Unreviewed install-time execution surface.

## Impact

Supply-chain compromise at install time — code execution before the app is audited.

## Remediation

Ban/allowlist install scripts, avoid curl-pipe installs, use official packages, review scripts in CI, run installs unprivileged.

## Regression Test

CI checking new deps for install scripts and flagging them for review.

## Common False Positives

Scripts in internal vetted packages; dev-tooling-only hooks.

## Related Skills

- dependency-analysis.md
- software-supply-chain.md
- command-injection.md

## References

- npm postinstall docs
- SLSA
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
