# Skill: Vendor Correlation

## Purpose

Correlate vendors/products across CVEs and advisories: vendor keys, product lines, CNAs, and per-vendor advisory feeds.

## Trigger Conditions

Activate when reviewing vendor map, product lines, cna.

## Investigation Method

1. Build the vendor map: canonical vendor keys, aliases, product lines (from CPE, advisory heads, OSV vendorProject).
2. Map CVEs to vendors/products; cluster by product line for portfolio-level reporting.
3. Track per-vendor advisory sources and their update cadence (vendors map to source-priority rules).
4. Support queries: all CVEs for a vendor/product line, vendor notification status (affects disclosure workflows).
5. Handle renames/forks of products with provenance (see package-identity-resolution).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Vendor map with product-line clusters and a sample portfolio query.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Vendor names treated as display strings.

## Impact

No portfolio-level CVE visibility; missed vendor-consolidated data.

## Remediation

Canonical vendor keys, product-line clusters, per-vendor source config.

## Regression Test

Vendor alias fixtures asserting canonicalization.

## False Positives

Two vendors sharing a CPE product name (common for standards-based products) - disambiguate by vendor key.

## Related Skills

- cpe-normalization.md
- vendor-advisory-ingestion.md
- source-priority.md

## References

- CPE vendor field
- CNA assignments
