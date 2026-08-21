# Skill: Secret Surface Discovery

## Purpose

Locate where secrets enter the system (env, files, vault, client), how they flow, and any exposure via code, logs, or configuration.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: secrets, keys, tokens, credentials.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Scan for secret patterns (API keys, tokens, private keys, connection strings) in code, config, tests, docs, container image history, and CI logs.
2. Trace how each legitimate secret reaches runtime (env -> config loader -> client) and whether it crosses trust boundaries (sent to frontend, logged).
3. Check git history for committed secrets (including reverted commits) and release artifacts.
4. Review secret rotation/revocation coverage for anything found.
5. Treat anything found as a sample; if a live secret is found, report it as an incident (rotate it) without displaying the value.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A secrets table: origin, reach, exposure path, live-vs-sample status. Never include the secret value in reports.

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

N/A — discovery; feeds hardcoded-secret-detection.

## Impact

Exposed secrets enable account takeover, data theft, and infrastructure compromise.

## Remediation

Use a secret manager, scan in CI (gitleaks/trufflehog), rotate any found live secret immediately.

## Regression Test

CI secret-scan failing on new commits; a test asserting no secret patterns in build output logs.

## Common False Positives

Test fixtures with obviously fake keys ("test", "example", "changeme") flagged as live secrets.

## Related Skills

- hardcoded-secret-detection.md
- secret-management.md
- environment-secret-analysis.md
- cloud-secret-analysis.md

## References

- OWASP Secrets Management Cheat Sheet
- CWE-798 (hard-coded credentials)
- CWE-256

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
