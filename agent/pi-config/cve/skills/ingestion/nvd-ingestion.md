# Skill: NVD Ingestion

## Purpose

Import NVD (NIST) data correctly: CVE API v2.0 JSON schema, pagination/cursors, and incremental updates.

## Trigger Conditions

Activate when reviewing nvd, nist, feed.

## Investigation Method

1. Use the NVD API 2.0 with resultsPerPage/pagination; honor lastModStartDate/lastModEndDate for incremental pulls.
2. Extract id, published, lastModified, descriptions, metrics (cvssMetricV31/V30/V2/V40), weaknesses (CWE), configurations (nodes, cpeMatch), references.
3. Set NVD-specific fields: status (Rejected/Reserved/Published), weakNumberInPackage, nvdLastModified, sourceIdentifier.
4. Handle rate limits (requestThrottling) with exponential backoff; store raw JSON per batch in databases/nvd/.
5. Cross-link each record to CVE.org identity (see record-merging) without silently overwriting.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A staged NVD batch imported with counts and spot-checks of representative records (published, metrics, cpes).

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

NVD schema drift or partial pagination leads to truncated caches.

## Impact

Missing affected-version data or stale severity from skipped pages.

## Remediation

Pagination-proof importer, schema validation, incremental cursoring, and a nightly verification job.

## Regression Test

Fixture-based tests replaying known API pages and asserting the normalized record shape.

## False Positives

NVD-only data used as final truth for affected versions (prefer vendor advisory).

## Related Skills

- cve-feed-ingestion.md
- cve-normalization.md
- cve-org-ingestion.md

## References

- NVD API 2.0 documentation
- NVD CVE JSON schema
