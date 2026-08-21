# Skill: Ecosystem Advisory Ingestion

## Purpose

Import package-ecosystem advisory databases (npm audit, PyPA OSV, Ruby Advisory DB, Alpine/Debian security trackers, ...).

## Trigger Conditions

Activate when reviewing ecosystem advisory, npm audit, pypi, ruby advisory db.

## Investigation Method

1. Identify ecosystem advisory sources: registry audits, OSV ecosystem feeds (PyPI, Go, crates, Pub, Hex, ...), distro trackers (Alpine secdb, Debian DSA/DLA).
2. Parse each format into package + affected ranges + fixed versions + CVE/GHSA refs.
3. Normalize package names per ecosystem rules (case, scopes, canonical naming) via language-ecosystem-map.
4. Handle distro-specific CVEs (DSA) that reference a CVE but affect distro packages with distro versions.
5. Merge into cve-package and cve-fix mappings with provenance per source.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Ecosystem advisory batch imported with package-name normalization and range integrity verified on samples.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Ecosystem-specific semantics (distro versioning, scope names, git ranges) treated uniformly.

## Impact

False applicability signals (wrong ranges) or missed fixes for ecosystem users.

## Remediation

Per-ecosystem parsers and range semantics, canonical package keys, provenance tagging.

## Regression Test

Fixture advisory records per ecosystem asserting normalized package and ranges.

## False Positives

Ecosystem advisory affecting a source build the project does not use (e.g., pip vs system package).

## Related Skills

- osv-ingestion.md
- github-advisory-ingestion.md
- cve-package-correlation.md

## References

- npm audit
- PyPA OSV
- Ruby Advisory DB
- Alpine secdb
