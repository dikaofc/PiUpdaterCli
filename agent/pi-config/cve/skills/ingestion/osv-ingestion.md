# Skill: OSV Ingestion

## Purpose

Import OSV.dev data (all.zip or per-ecosystem queries) and map OSV records to CVEs, affected ranges, and ecosystem packages.

## Trigger Conditions

Activate when reviewing osv, osv.dev, ecosystem records.

## Investigation Method

1. Fetch the full OSV export (all.zip) or use OSV API queries (GET /v1/query with package+version, /v1/vulns/{id}).
2. Parse schema-2.0 records: id (OSV-* or GHSA-* or CVE-*), affected[] (package: ecosystem+name, ranges, versions), severity[], references[], aliases (CVE IDs).
3. Link OSV ids to CVEs via aliases; record the ecosystem package names for cve-package mapping.
4. Handle range types (SEMVER, ECOSYSTEM, GIT) through version-normalization.
5. Deduplicate CVE-centric records that arrive via multiple OSV entries (same CVE from several ecosystems).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

OSV records imported with ecosystem/range integrity and a successful alias→CVE link count.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

OSV ecosystems and range semantics misread (e.g., ECOSYSTEM ranges using distribution versions).

## Impact

Wrong affected ranges for ecosystem packages; missed aliases.

## Remediation

Validate ranges per ecosystem, resolve aliases to canonical CVE IDs, and keep ecosystem-name mappings normalized.

## Regression Test

Tests on fixture OSV records (semver/ecosystem/git ranges) asserting normalized ranges.

## False Positives

OSV records without CVE aliases (OSV-only advisories) — still ingested under advisory identity, not a fake CVE.

## Related Skills

- ecosystem-advisory-ingestion.md
- version-normalization.md
- cve-package-correlation.md

## References

- OSV schema
- OSV API docs
