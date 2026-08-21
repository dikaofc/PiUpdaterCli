# Skill: Advisory Correlation

## Purpose

Correlate advisories across sources for the same CVE/flaw: vendor, GitHub, OSV, distro, ecosystem.

## Trigger Conditions

Activate when reviewing advisory correlation, linking.

## Investigation Method

1. Collect all advisories referencing a canonical CVE ID from every ingested source.
2. Link advisories that describe the same flaw without a CVE (similarity heuristics) but keep them individually queryable.
3. Build cve-advisory mapping: CVE → advisory list with source and priority.
4. Summarize consensus/dissensus: affected ranges, fixed versions, severity agreement.
5. Ensure the correlation itself is idempotent and provenance-preserving.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Correlated advisory groups with consensus/dissensus summaries per CVE sample.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Advisories quarantined per source prevent cross-source judgment.

## Impact

Conflicting range/severity data surfaced late in triage.

## Remediation

Canonical CVE-centric advisory groups, consensus summaries, discrepancy flagging.

## Regression Test

Correlation fixture tests asserting group membership and consensus flags.

## False Positives

Same-named advisory entries that are actually different (e.g., different distro rebuilds) — verify by CVE and range.

## Related Skills

- record-merging.md
- cve-advisory-correlation.md
- cve-normalization.md

## References

- source-priority.md
