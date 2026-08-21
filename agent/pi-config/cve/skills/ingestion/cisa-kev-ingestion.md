# Skill: CISA KEV Ingestion

## Purpose

Import the CISA Known Exploited Vulnerabilities catalog: full snapshot and incremental additions, preserving due dates and actions.

## Trigger Conditions

Activate when reviewing cisa, kev, known exploited.

## Investigation Method

1. Fetch the KEV JSON (cisa.gov/known-exploited-vulnerabilities-catalog) snapshot; keep catalogVersion and dateReleased.
2. Extract cveID, vendorProject, product, vulnerabilityName, dateAdded, shortDescription, requiredAction, dueDate, knownRansomwareCampaignUse.
3. Store as a first-class index (cisa-kev) and flag records in the normalized CVE record (knownExploitation, exploitStatus).
4. Check removals: KEV entries may be removed; reconcile the index accordingly.
5. Never use KEV alone to declare a project exploitable — it is a priority signal, not an applicability verdict.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

KEV snapshot imported with dated entries, a removal/change check, and correlation to the normalized CVE index.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

KEV treated as a static list or as proof of exploitation in a specific app.

## Impact

Mis-prioritization (over- or under-ranking) of remediation work.

## Remediation

Keep KEV as a dated, diffable index; expose knownExploitation as a triage input only.

## Regression Test

Tests asserting KEV-derived flags and due-date handling, including removals.

## False Positives

KEV presence implying specific-project exploitability (it indicates in-the-wild exploitation, not your reachability).

## Related Skills

- cve-kev-correlation.md
- cve-known-exploitation-priority.md
- cve-triage-engine.md

## References

- CISA KEV catalog JSON
- BOD 22-01
