# Skill: Environment Secret Analysis

## Purpose

Audit environment-based secrets: env var handling, .env files, orchestration injection, and exposure to unintended processes.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: env secrets, .env, environment variables.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find where env vars are declared: .env files, CI variables, orchestration (K8s secrets, ECS, Cloud Run), build args.
2. Check repository coverage: .env committed? .env.example with real values?
3. Check process exposure: secrets visible to all processes in the container? build-time secrets baked into images?
4. Check override behavior: precedence rules (dev env overrides prod?), validation of presence.
5. Check logs/errors containing env secrets.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- Env-source inventory with exposure paths cited; any committed .env or baked build secret is a finding.

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

Convenience env-file workflows leaking into repos/images or overly broad process scope.

## Impact

Credential exposure via repo/image/process inspection.

## Remediation

Secret manager injection, minimal process scope, build secrets not baked, validate secret presence at boot, .env in gitignore.

## Regression Test

CI checks failing on committed .env-like files; image-layer scans.

## Common False Positives

Dev-only .env.example with placeholder values documented.

## Related Skills

- secret-management.md
- hardcoded-secret-detection.md
- environment-analysis.md

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
