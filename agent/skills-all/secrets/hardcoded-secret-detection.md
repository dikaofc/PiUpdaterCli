# Skill: Hardcoded Secret Detection

## Purpose

Detect secrets committed to repositories (keys, tokens, passwords, DB strings) including history, images, and docs.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: hardcoded secret, committed secret, token scan, gitleaks.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Scan the working tree: regex + entropy signals for API keys (sk-, AIza, AKIA), tokens (ghp_, xoxb), private keys, passwords, connection strings.
2. Scan git history: all commits, including reverted ones (secrets persist in history).
3. Scan artifacts: config templates, examples, Docker images (layers), CI logs, docs.
4. Classify: live vs sample/test. A live secret is an incident — rotate and report without exposing value.
5. Verify reachability: does the exposed secret grant access (API key still valid)?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A secrets report with file/history location, pattern type, live-vs-sample status, and rotation action — values redacted.

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

Scan local repositories for secret patterns using sample/seed files; treat any real secret found as a high-priority incident and rotate, never display it.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Lack of pre-commit scanning and insecure developer workflows (env files committed).

## Impact

Full authentication compromise of linked services.

## Remediation

Pre-commit/CI secret scanning, .gitignore for env files, rotate any live secret, history rewriting for active repos followed by key rotation.

## Regression Test

CI gate failing on secret patterns in new commits and history scans.

## Common False Positives

Fake/test keys (test, example, changeme patterns) correctly classified as samples.

## Related Skills

- secret-surface-discovery.md
- secret-management.md
- environment-secret-analysis.md

## References

- OWASP Secrets Management Cheat Sheet
- CWE-798

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
