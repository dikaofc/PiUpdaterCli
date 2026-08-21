# Skill: CVSS Normalization

## Purpose

Normalize CVSS scores/vectors from all sources, preserving the version (v2/v3.0/v3.1/v4) and provenance.

## Trigger Conditions

Activate when reviewing cvss, vector, versions.

## Investigation Method

1. Parse vectors: AV/AC/PR/UI/S/C/A for v3.x, plus v4 (AV/AC/AT/PR/UI/VC/VI/VA/SC/SI/SA), v2 (AV/AC/Au/C/I/A).
2. Validate component values against the version spec before storing.
3. Keep a list of (version, source, score, vector) rather than a single scalar; derive the canonical value by source-priority.
4. Recompute score from vector where feasible to catch metadata errors.
5. Tag unknown/malformed vectors as UNKNOWN, not 0.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

CVSS records per version with vector validation and a canonical-selection rule applied with provenance.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Mixing CVSS versions or trusting malformed vectors.

## Impact

Severity ranking corrupted by wrong CVSS interpretation.

## Remediation

Version-tagged vectors, spec validation, recompute checks, explicit canonical selection.

## Regression Test

Vector validation/recompute test vectors per CVSS version.

## False Positives

Score-only data without vectors (advisories) — store score while recording missing vector.

## Related Skills

- cvss-v3-analysis.md
- cvss-v4-analysis.md
- cve-severity-analysis.md

## References

- FIRST CVSS v3.1 spec
- FIRST CVSS v4.0 spec
