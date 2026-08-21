# Skill: CWE Normalization

## Purpose

Normalize CWE references from all sources into the canonical CWE-ID form with confidence tagging.

## Trigger Conditions

Activate when reviewing cwe, weakness mapping.

## Investigation Method

1. Parse CWE references (CWE-79, CWE-79:CWE-80 chains, "CWE-79 (Improper Neutralization...)").
2. Map to canonical CWE IDs (4-digit with leading zeros), resolve parent/child relationships from the CWE hierarchy.
3. Tag confidence: authoritative (NVD weaknesses array, advisory) vs inferred (from description keywords) vs unknown.
4. Keep chains (CWE-79:CWE-80) intact as ordered pairs.
5. Link to CWE→skill mappings for triage routing (cve-cwe-correlation).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Normalized CWE list per record with confidence tags and chain preservation verified.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

CWE treated as free text; chains and confidence lost.

## Impact

Wrong skill routing and wrong remediation families.

## Remediation

Canonical IDs, confidence tags, chain preservation, hierarchy-aware queries.

## Regression Test

Fixture tests on chain parsing and confidence tagging.

## False Positives

Description keywords implying a CWE without authoritative data — keep inferred tag, do not assert.

## Related Skills

- cve-cwe-correlation.md
- cve-normalization.md
- cwe-family-analysis.md

## References

- MITRE CWE
- CWE Top 25
