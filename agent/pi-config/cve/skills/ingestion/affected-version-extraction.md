# Skill: Affected-Version Extraction

## Purpose

Extract affected (vulnerable) version ranges per product/package, normalized and sourced.

## Trigger Conditions

Activate when reviewing affected version, vulnerable range.

## Investigation Method

1. Collect affected-version data: NVD CPE ranges, OSV affected[].versions, GHSA vulnerable ranges, vendor advisory lists.
2. Normalize intervals per ecosystem; express as [start, end) or explicit version lists with semantics preserved.
3. Merge across sources into cve-package affected ranges with source priority for the authoritative verdict.
4. Distinguish "affected" (vulnerable) from "unknown" (no data) — absence of data is not safety.
5. Handle "all versions" (e.g., affectedVersions: ["*"]) explicitly.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Affected-range records with per-source provenance and normalized intervals; unknown ranges marked.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Absent version data treated as not-affected.

## Impact

False-negative applicability (missed vulnerable installs).

## Remediation

Explicit affected ranges, three-state matching (affected/not/unknown), provenance.

## Regression Test

Range-interval tests per ecosystem and a three-state membership test.

## False Positives

Ranges that include fixed versions because of inclusive-endpoint errors — validate endpoints.

## Related Skills

- fixed-version-extraction.md
- cve-version-matching.md
- version-normalization.md

## References

- OSV schema ranges
- NVD configurations
