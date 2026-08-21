# Skill: Reference Extraction

## Purpose

Extract and classify references from CVE/advisory records: advisories, patches, PoC, vendor pages, NVD tags.

## Trigger Conditions

Activate when reviewing references, links, tags.

## Investigation Method

1. Extract all reference URLs and their tags from NVD (Reference Tags: Patch, Vendor Advisory, Exploit, Third Party Advisory, ...) and source advisories.
2. Classify each: patch references (commits, PRs), vendor advisories, PoC/exploit (handle with defensiveness), documentation, OSS-Fuzz, etc.
3. Resolve obvious redirect/aliasing (github.com/org/repo/commit/...) for patch identification.
4. Link patch references into cve-fix mapping.
5. Record URL + classification + source; never follow untrusted links at runtime automatically.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Extracted references classified with counts per class and patch links resolved into cve-fix.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

References stored as an untyped URL blob.

## Impact

Missed patches and missed fix analysis opportunities.

## Remediation

Typed references, patch resolution, defensive handling of PoC links.

## Regression Test

Fixture tests on tag parsing and commit-URL extraction.

## False Positives

Reference tags that are wrong in the source — classify by content inspection with evidence.

## Related Skills

- patch-extraction.md
- cve-fixed-version.md
- cve-advisory-correlation.md

## References

- NVD reference tags
