# Skill: Version Normalization

## Purpose

Normalize version strings and ranges across ecosystems (semver, PEP440, Maven, NuGet, RPM, Debian) for safe comparison.

## Trigger Conditions

Activate when reviewing semver, range, version scheme.

## Investigation Method

1. Classify the version scheme by ecosystem (semver, pep440, rpmver, debian version, calver, date-based, ...).
2. Parse version components (major/minor/patch, pre-release, build) per scheme; handle suffixes (rc, beta, dev, snapshot).
3. Normalize range expressions (>=x, <y, (a,b], "-" ranges, ECOSYSTEM ranges) into a canonical interval form.
4. Resolve aliases: e.g., Maven 3.8.1.Final vs 3.8.1, Ruby pre-release sorting, Go pseudo-versions.
5. Reject unparseable versions as UNKNOWN — never guess ordering.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A normalization table: raw version/range → canonical interval, with per-ecosystem test cases.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Treating all versions as plain semver leads to wrong range membership.

## Impact

Applicability and fixed-version verdicts wrong by a patch level.

## Remediation

Use per-ecosystem comparators, emit canonical intervals, keep raw strings for display.

## Regression Test

Ecosystem-version test vectors asserting ordering and membership.

## False Positives

Version strings that are effectively opaque (hashes, distro epochs) — compare only within scheme.

## Related Skills

- cve-version-matching.md
- cpe-normalization.md
- cve-range-analysis.md

## References

- node-semver
- PEP 440
- RPM version comparison
