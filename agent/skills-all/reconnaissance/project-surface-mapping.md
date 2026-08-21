# Skill: Project Surface Mapping

## Purpose

Build a complete inventory of the project: modules, entry points, data stores, external integrations, and exposed functionality before any deep analysis.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: project map, surface, blueprint, modules.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. List the repository layout (monorepo, packages, apps) and identify each deployable unit.
2. Inventory runtime entry points: HTTP servers, CLI commands, workers, schedulers, webhook handlers, message consumers, cron jobs.
3. Map data stores (databases, caches, queues, object storage) and which modules access them.
4. List external integrations (third-party APIs, SDKs, webhooks, SSO providers) and their credentials.
5. Identify the build/deploy targets and any difference between dev/test/prod configuration.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A written surface map listing every entry point, store, and integration with file references. Gaps are marked UNKNOWN, never assumed.

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

N/A for this skill — it produces the map used by other skills to locate root causes.

## Impact

A missing surface map creates blind spots where vulnerabilities hide in unmapped modules.

## Remediation

Keep an architecture map (ADRs, docs) or regenerate it from code; treat new entry points as review triggers.

## Regression Test

A CI check that fails when new entry points are added without a surface-map update.

## Common False Positives

Assuming a file is an entry point from its name alone; ignoring test/util scripts not reachable in production.

## Related Skills

- repository-structure-analysis.md
- entrypoint-discovery.md
- attack-surface-mapping.md

## References

- OWASP ASVS V12 (security architecture)
- CWE-1007 (insufficient hardening of entry points)

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
