# Skill: CVSS v3 Vector Validation

## Purpose

Validate CVSS v3.x vectors: component legality, value enumeration, and score recomputation.

## Trigger Conditions

Activate when reviewing v3 vector, validation, recompute.

## Investigation Method

1. Parse the vector into components (AV/AC/PR/UI/S/C/I/A) and validate each value against the v3 spec enumeration.
2. Check the vector format (slash-separated, no spaces, allowed values).
3. Recompute the base score with the official v3 equations; compare to the published score.
4. Flag and record discrepancies; investigate the cause (rounding, environmental metrics, wrong version).
5. Output validated canonical vector + score.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Vector validation results: parse OK/error, recompute match/mismatch, discrepancy analysis.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Malformed or mis-versioned vectors in source data.

## Impact

Wrong severity numbers propagate.

## Remediation

Strict vector validation, recompute checks, discrepancy records.

## Regression Test

Official v3 example vectors (valid) and tampered fixtures (invalid) asserting outcomes.

## False Positives

Round-1 vs round-2 score rounding differences across calculators - use one canonical implementation.

## Related Skills

- cvss-normalization.md
- cvss-v3-analysis.md
- cve-severity-analysis.md

## References

- CVSS v3.1 equations
- FIRST examples
