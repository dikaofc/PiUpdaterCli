# Skill: Static Analysis

## Purpose

Run and interpret static analysis for security defects: SAST tools, taint analysis, and secret scanning.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: sast, static analysis, semgrep, codeql, taint.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Select tools for the language stack: Semgrep, CodeQL, Bandit, Brakeman, ESLint security, gosec, etc.
2. Configure rulesets: security-focused, tuned to the stack (framework-aware).
3. Run on the codebase, including tests/build files where relevant.
4. Triage results: confirm true positives with code reading, filter noise.
5. Convert confirmed findings into the audit report and fixes.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- SAST run output with triage: confirmed findings linked to code lines and severity.

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

Run linters/semgrep/codeql on a local checkout; triage results by tracing code paths before reporting.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Common defect classes (injection, unsafe sinks, secret patterns) that static tools catch.

## Impact

Missed common vulnerabilities without automated scanning.

## Remediation

CI-integrated SAST with gating on high-severity confirmed findings, rule tuning.

## Regression Test

New rules/checks added as the codebase evolves.

## Common False Positives

Tool noise (template files, generated code) — exclude generated paths.

## Related Skills

- code-review.md
- dependency-analysis.md
- hardcoded-secret-detection.md

## References

- OWASP SAST
- Semgrep/CodeQL docs

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
