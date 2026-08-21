# Skill: CVSS v3 Analysis

## Purpose

Analyze CVSS v3.0/3.1 vectors and scores in detail: parse components, understand metric semantics, and compute/recompute scores.

## Trigger Conditions

Activate when reviewing cvss v3, vector parsing, environmental.

## Investigation Method

1. Parse v3.x vectors: AV, AC, PR, UI, S, C, I, A.
2. Apply the v3.1 base equation to recompute the score from the vector; flag discrepancies with published values.
3. Interpret metric semantics for impact statements (e.g., Scope=Changed cases).
4. Assess temporal/environmental metrics only when explicitly provided; do not invent them.
5. Output the canonical base score with vector breakdown.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Vector parse + recomputed score + semantic notes; discrepancies flagged.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Score copied from aggregators without vector validation.

## Impact

Wrong severity in triage and reports.

## Remediation

Recompute-from-vector checks, semantic interpretation, provenance.

## Regression Test

CVSS v3 recompute test vectors (official examples).

## False Positives

v3.0 vs v3.1 differences treated as errors - both are valid with version tagging.

## Related Skills

- cvss-normalization.md
- cve-severity-analysis.md

## References

- CVSS v3.1 specification
- FIRST official examples
