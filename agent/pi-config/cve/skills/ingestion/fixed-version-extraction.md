# Skill: Fixed-Version Extraction

## Purpose

Extract and normalize fixed/patched version information from advisories, OSV, GHSA, distro trackers.

## Trigger Conditions

Activate when reviewing fixed version, patched version.

## Investigation Method

1. Collect all "fixed/patched/introduced" events: OSV ranges (events), GHSA vulnerable ranges, vendor advisory version lists.
2. Normalize versions per ecosystem (version-normalization).
3. Compute the first fixed version as the minimum of all fixed events (per source), recording source-specific lists.
4. Detect contradictions (different fixed versions across sources) and preserve them with provenance.
5. Expose fixedVersions[] on the canonical record for remediation engine.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Fixed-version extraction with per-source lists and a computed first-fixed (or UNKNOWN) with provenance.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

First-fixed derived from one source only or from mis-normalized versions.

## Impact

Wrong upgrade targets or premature "no fix" conclusions.

## Remediation

Multi-source collection, normalized comparison, contradiction preservation.

## Regression Test

Fixture ranges asserting the correct first-fixed computation.

## False Positives

Distro-patched versions differing from upstream — both are valid fixed versions for different consumers.

## Related Skills

- affected-version-extraction.md
- cve-fixed-version.md
- version-normalization.md

## References

- OSV range semantics
- GHSA events
