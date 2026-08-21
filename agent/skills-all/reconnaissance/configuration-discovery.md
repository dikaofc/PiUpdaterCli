# Skill: Configuration Discovery

## Purpose

Find and inventory configuration (env, files, IaC, feature flags) that changes behavior, security controls, or data exposure.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: config, env, feature flags, settings.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List config sources: env vars, config files, secret managers, DB-backed settings, remote feature-flag services, CLI defaults.
2. For each security-sensitive setting (auth mode, TLS, CORS, upload limits, debug mode, rate limits) find where it is read.
3. Compare default config vs production override (deployment manifests) and flag divergence.
4. Find hardcoded fallbacks triggered when config is missing (insecure defaults).
5. Check whether feature flags default to safe values.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Config inventory with default vs deployed values referenced by file. "Insecure default" claims need the actual default code path quoted.

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

N/A — discovery; feeds configuration-audit.

## Impact

Misconfiguration is a leading cause of data exposure (cloud storage, debug, CORS).

## Remediation

Centralize config schema, validate at startup, provide safe defaults and fail-closed behavior.

## Regression Test

Startup validation test failing when an unsafe config value is set without explicit override.

## Common False Positives

Assuming deployed config equals repo defaults; flagging intentionally documented dev-only settings.

## Related Skills

- configuration-security.md
- environment-analysis.md
- configuration-audit.md

## References

- OWASP Configuration Review checklist
- CWE-16 (configuration)

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
