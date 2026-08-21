# Skill: Serverless Security

## Purpose

Audit serverless functions (Lambda/Cloud Functions/CF): permissions, event injection, cold-start config, and dependency size.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: serverless, lambda, cloud function, event injection.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Inventory functions: triggers, IAM roles, runtimes, dependency bundles.
2. Check function IAM: least privilege per function, no overly broad roles.
3. Check event injection: untrusted event fields reaching queries/commands/paths.
4. Check config: timeouts/memory bounds (cost DoS), env var secrets, layers.
5. Check supply chain: bundled deps, lockfile, versions.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A function inventory with role/permission and event-flow findings cited.

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

Use cloud provider policy simulators and read-only IAM policy evaluation on your own account only.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Broad function roles and event data treated as trusted.

## Impact

Privilege escalation from a function, data exposure, cost abuse.

## Remediation

Per-function least-privilege roles, validate event input like any untrusted input, secrets via env/manager, pinned deps.

## Regression Test

Policy checks per function + event-fuzz tests.

## Common False Positives

Functions with only public triggers doing non-sensitive work.

## Related Skills

- cloud-iam-analysis.md
- cloud-config-review.md
- event-injection.md

## References

- AWS Lambda security best practices
- CWE-669

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
