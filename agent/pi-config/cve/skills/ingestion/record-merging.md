# Skill: Record Merging

## Purpose

Merge records for the same canonical CVE with explicit, provenance-preserving conflict rules.

## Trigger Conditions

Activate when reviewing merge, conflict resolution, provenance.

## Investigation Method

1. Define the merge strategy: identity from CVE.org, affected/fixed versions from vendor advisory > project advisory > CVE/NVD > OSV > others, CVSS from the most authoritative vector, description from NVD with enrichment.
2. For each conflicting field, preserve both values with per-field source tags rather than silently choosing.
3. Compute merged confidence: lower when sources conflict; record the discrepancy list on the record.
4. Keep a changelog per record (who/what/when merged, prior values).
5. Idempotent re-merge: re-running the same merge yields the same output.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Merged records with per-field provenance and an explicit discrepancy list; a re-merge idempotency check.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Silent overwriting of conflicting fields loses information and erodes trust.

## Impact

Wrong version ranges, wrong severity, untraceable decisions.

## Remediation

Per-field provenance, conflict lists, merge changelogs, idempotent merges.

## Regression Test

Merge determinism tests and conflict-resolution tests per field type.

## False Positives

Records that are already single-source (no merge needed) — skip merge, keep as-is.

## Related Skills

- duplicate-detection.md
- cve-normalization.md
- advisory-correlation.md

## References

- source-priority.md
