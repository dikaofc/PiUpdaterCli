# Skill: CVSS v4 Vector Validation

## Purpose

Validate CVSS v4.0 vectors: new metric sets, derived metrics, and v4 score recomputation.

## Trigger Conditions

Activate when reviewing v4 vector, validation, recompute.

## Investigation Method

1. Parse v4 vectors: base (AV/AC/AT/PR/UI), vulnerable-system impact (VC/VI/VA), subsequent-system impact (SC/SI/SA), plus supplemental (S/A, MSI/MSA, E/AU/R/V/RE/U).
2. Validate each value against the v4 enumeration; validate the supplemental-system consistency.
3. Compute derived base metrics (MAV/MAC/MAT/MPR/MUI and impact metrics) where required.
4. Recompute the v4 score using the official equations; compare with the published value.
5. Flag discrepancies and version mismatches (v3 vector labeled v4 and vice versa).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

v4 validation results with derived-metric computation and recompute comparison.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

v4 vectors validated with v3 rules or not validated at all.

## Impact

Invalid v4 scores in severity analysis as v4 adoption increases.

## Remediation

Version-specific validation, derived-metric computation, recompute checks.

## Regression Test

Official v4 example vectors and invalid fixtures.

## False Positives

v4 supplemental metric groups absent - they are optional, not errors.

## Related Skills

- cvss-normalization.md
- cvss-v4-analysis.md
- cve-severity-analysis.md

## References

- CVSS v4.0 specification equations
