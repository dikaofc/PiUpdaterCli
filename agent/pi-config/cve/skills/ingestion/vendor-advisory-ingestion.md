# Skill: Vendor Advisory Ingestion

## Purpose

Import vendor security advisories (Apache, Microsoft, Spring, WordPress, Red Hat, etc.) and treat them as affected-version authority.

## Trigger Conditions

Activate when reviewing vendor advisory, cna, advisory parsing.

## Investigation Method

1. Collect advisories per vendor from release feeds, security pages, mailing lists, or CNA APIs.
2. Extract advisory id, CVE refs, affected versions (often the most accurate), fixed versions, workarounds, and links.
3. Parse structured fields where present (JSON/XML feeds); fall back to reviewer extraction for prose advisories with provenance.
4. Store in advisories/vendor/<vendor>/ preserving original + extracted fields.
5. Feed vendor-derived affected/fixed versions into the normalized record preferentially (source-priority).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

An advisory import with per-vendor affected/fixed parsing and a priority-based merge into the affected-version mapping.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Vendor advisories ignored in favor of aggregated feeds, losing precise version ranges.

## Impact

Wrong applicability verdicts on real projects (missing affected patch levels).

## Remediation

Prioritize vendor advisories for affected/fixed versions, keep the original document, tag confidence.

## Regression Test

Per-vendor fixture advisories asserting correct version extraction.

## False Positives

Vendor prose using different version schemes (e.g., "all prior releases") — normalize with version-normalization.

## Related Skills

- affected-version-extraction.md
- cve-advisory-correlation.md
- fixed-version-extraction.md

## References

- Apache security pages
- Microsoft security advisories
- CNA rules
