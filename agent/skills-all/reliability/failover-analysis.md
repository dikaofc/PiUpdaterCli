# Skill: Failover Analysis

## Purpose

Audit failover/HA paths: are security controls (auth, rate limits, tenant scoping) present on all replicas and standby paths?

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: failover, ha, standby, replica.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Map HA topology: replicas, standby, multi-region, DR sites.
2. Check config parity: security settings identical across environments/regions?
3. Check routing: standby accepts traffic with same auth?
4. Check data: replica consistency during failover (stale reads on security decisions).
5. Check DR drills: failover exercised regularly?



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A topology review with config parity evidence and a stale-read/standby-auth finding if present.

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

Use fault-injection tests (chaos-style, local) that simulate partial failures; assert graceful degradation in tests.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Configuration drift between primary and standby paths.

## Impact

Security controls silently absent during failover; stale data decisions.

## Remediation

IaC-driven parity, config tests across regions, regular failover drills, read-your-writes consistency for security decisions.

## Regression Test

Cross-region config tests and failover drills in staging.

## Common False Positives

Single-region systems with documented RTO/RPO and drill results.

## Related Skills

- reliability-failure-analysis.md
- cloud-config-review.md
- database-replication-analysis.md

## References

- AWS Well-Architected
- CWE-668

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
