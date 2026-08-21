# Skill: Attack Surface Mapping

## Purpose

Combine surface, entry points, endpoints, dependencies, config, secrets, and trust boundaries into a prioritized attack surface for the review.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: attack surface, risk map, prioritization.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Merge the outputs of the other discovery skills into one attack-surface register.
2. Score each surface element by exposure (reachable by whom), sensitivity (data touched), and criticality (system role).
3. Mark elements reachable pre-auth vs post-auth (pre-auth is highest priority).
4. Identify high-value targets: admin functions, money movement, PII stores, secrets, backup systems.
5. Produce a prioritized review plan: pre-auth paths first, then auth paths by privilege level.



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A prioritized register: surface item, exposure, sensitivity, priority order, and the skills that will investigate it.

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

N/A — synthesis skill.

## Impact

Without prioritization, reviews waste time on low-value areas and miss critical pre-auth paths.

## Remediation

Keep the register in the review doc; revisit after each audit cycle.

## Regression Test

N/A (process) — recommend updating the register whenever new entry points are discovered.

## Common False Positives

Prioritizing by code size instead of exposure; ignoring entry points that are hard to reach.

## Related Skills

- project-surface-mapping.md
- entrypoint-discovery.md
- trust-boundary-discovery.md

## References

- OWASP ASVS V1
- CWE-1007

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
