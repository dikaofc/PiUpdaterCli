# Skill: Duplicate Detection

## Purpose

Detect duplicate CVE records across feeds: same CVE via multiple advisories, alias chains, and near-duplicate advisories.

## Trigger Conditions

Activate when reviewing duplicate, dedup, canonical id.

## Investigation Method

1. Canonicalize identifiers: CVE IDs (CVE-YYYY-NNNNN, case/format), GHSA ids, OSV ids, distro ids (DSA/DLA).
2. Build alias resolution: OSV aliases, GHSA cve_id, distro mapping to CVE.
3. Detect advisories without a CVE that describe the same flaw as one that has one (similarity signals: package + range + summary).
4. Apply the rule: one canonical record per CVE ID; advisory identities are separate but linked.
5. Never auto-merge uncertain duplicates — flag for review with evidence.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A duplicate-detection run reporting: duplicates merged (with ids), near-duplicate candidates flagged, and none silently dropped.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Multiple sources describing the same CVE are inserted as separate rows.

## Impact

Inflated counts, split triage, double remediation.

## Remediation

Canonical-record-per-CVE enforcement, alias links, review queue for fuzzy matches.

## Regression Test

Tests with known alias chains asserting single canonical records.

## False Positives

Two advisories that only share a package but describe different CVEs — keep as separate records.

## Related Skills

- record-merging.md
- osv-ingestion.md
- cve-normalization.md

## References

- CVE ID syntax
- OSV alias field semantics
