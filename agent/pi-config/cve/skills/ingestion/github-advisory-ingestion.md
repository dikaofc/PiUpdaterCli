# Skill: GitHub Advisory Ingestion

## Purpose

Import GitHub Security Advisories (GHSA records) and map them to CVEs, ecosystems, and vulnerable ranges.

## Trigger Conditions

Activate when reviewing github advisory, ghsa.

## Investigation Method

1. Use the GHSA API (api.github.com/advisories) or OSV GHSA records; support pagination and filters.
2. Extract ghsa_id, cve_id, summary, severity (GHSA levels), cvss, cwes, ecosystem, vulnerable ranges (events: introduced/fixed/last_affected), references.
3. Map GHSA ecosystem names (npm, PyPI, Maven, NuGet, Go, RubyGems, crates.io, ...) to canonical ecosystem keys.
4. Preserve advisory-level metadata (withdrawn?, ghsa severity) alongside CVE-level normalization.
5. Reconcile multiple advisories pointing at the same CVE (see record-merging).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

GHSA batch imported with ecosystem mapping and a reconciliation report against existing CVE records.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Ecosystem name drift and range-event interpretation errors.

## Impact

Missed fixed versions or wrong affected ranges for GitHub-hosted packages.

## Remediation

Normalize ecosystem keys and range events (introduced/fixed), treat advisory severity as advisory-level (not final).

## Regression Test

Fixture tests on multi-event ranges asserting min/max endpoints.

## False Positives

GHSA severity differing from NVD CVSS — preserve both with provenance.

## Related Skills

- ecosystem-advisory-ingestion.md
- affected-version-extraction.md
- fixed-version-extraction.md

## References

- GitHub Advisories API
- GHSA format
