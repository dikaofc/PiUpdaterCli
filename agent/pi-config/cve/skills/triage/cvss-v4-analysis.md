# Skill: CVSS v4 Analysis

## Purpose

Analyze CVSS v4.0 vectors: new metrics (AT, VC/VI/VA, SC/SI/SA, MSI/MSA), and v4 semantics including derived metric groups.

## Trigger Conditions

Activate when reviewing cvss v4, vector, threat metrics.

## Investigation Method

1. Parse v4 vectors: AV, AC, AT, PR, UI, VC, VI, VA, SC, SI, SA (plus supplemental S/A, MSI/MSA, E/AU/R/V/RE/U).
2. Understand v4 differences: no Scope, separate confidentiality/integrity/availability for vulnerable system vs subsequent system.
3. Recompute the v4 score from the vector using the official equations (including derived base metrics).
4. Handle v4 vulnerability vs subsequent-system combinations in impact interpretation.
5. Tag records with v4 version explicitly; note that many records still carry only v3.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

v4 vector parse with recomputed score and semantic notes.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

v4 vectors treated with v3 semantics (or ignored).

## Impact

Mis-scored v4 records as v4 adoption grows.

## Remediation

Version-explicit analysis, v4-specific recomputation, semantics documentation.

## Regression Test

Official CVSS v4 example vectors asserting recomputed scores.

## False Positives

Mixing v4 and v3 scores in comparisons without version normalization.

## Related Skills

- cvss-normalization.md
- cve-severity-analysis.md

## References

- CVSS v4.0 specification
- FIRST v4 examples
