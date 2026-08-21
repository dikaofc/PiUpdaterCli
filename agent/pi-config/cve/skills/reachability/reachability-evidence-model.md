# Skill: Reachability Evidence Model

## Purpose

Assign evidence levels to reachability verdicts so that claims are graded by the strength of the proof behind them.

## Trigger Conditions

Activate when reviewing evidence level, e0-e5, proof chain.

## Investigation Method

1. Use the evidence scale: E0 none, E1 lockfile/manifest only, E2 package presence + version match, E3 import/call evidence, E4 call path + input source traced, E5 verified execution in deployed configuration.
2. Map each reachability classification to the minimum evidence level that supports it (DIRECTLY_REACHABLE requires E4+; PRESENT_BUT_UNUSED requires E3 import absence check).
3. Attach the evidence level to the recorded classification and to any report claim.
4. Downgrade claims automatically when evidence is missing (a claim without its required level reverts to UNKNOWN).
5. Keep the evidence record per CVE: what was inspected, when, and by which tool/person.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Per-CVE evidence levels with classification mapping; a report sample showing E-level attribution.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Verdicts asserted without graded proof.

## Impact

Confidence inflation; unverifiable claims in reports.

## Remediation

Evidence-level gate for each classification, automatic downgrade on missing evidence.

## Regression Test

Evidence-gate tests asserting downgrade behavior.

## False Positives

Tool output cited as evidence without confirming the tool inspected the right artifact.

## Related Skills

- reachability-classification.md
- cve-reachability-engine.md
- cve-confidence-model.md

## References

- evidence model in root docs
