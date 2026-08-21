# Skill: Reachability Classification

## Purpose

Assign and record the standardized reachability classification for each CVE candidate.

## Trigger Conditions

Activate when reviewing classification, directly reachable, unknown.

## Investigation Method

1. Apply the taxonomy exactly: DIRECTLY_REACHABLE - the vulnerable function is called on an attacker-influenceable path in the deployed configuration (evidence required).
2. TRANSITIVELY_REACHABLE - reachable through an intermediate dependency call chain (the path runs through another package).
3. PRESENT_BUT_UNUSED - the vulnerable code is present but no project code invokes it.
4. CONDITIONALLY_REACHABLE - reachable only under specific configuration/feature/privilege conditions (name the condition).
5. UNREACHABLE - proven that no path exists (e.g., function absent, feature disabled, no imports).
6. UNKNOWN - insufficient evidence; do not default to reachable.
7. Record the classification with the evidence level and any condition, on the CVE record.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Classification per CVE with the supporting evidence link and condition statement; a classification summary table.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Missing standardized classification; "in lockfile" defaulted to "reachable".

## Impact

Unreliable priority lists and false exploitability claims.

## Remediation

Standardized taxonomy, evidence-linked classifications, UNKNOWN-first default.

## Regression Test

Classification mapping tests; report gates requiring classification before severity finalization.

## False Positives

Classify the path, not the package: the same CVE can be DIRECTLY_REACHABLE in one service and PRESENT_BUT_UNUSED in another.

## Related Skills

- cve-reachability-engine.md
- cve-triage-engine.md
- cve-severity-analysis.md

## References

- GitHub reachability studies
- snyk reachability
