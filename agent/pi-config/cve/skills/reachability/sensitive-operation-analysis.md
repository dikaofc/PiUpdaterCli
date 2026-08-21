# Skill: Sensitive Operation Analysis

## Purpose

Determine the sensitive operation reachable via the vulnerable path (code execution, data read/write, auth bypass, DoS) to ground impact.

## Trigger Conditions

Activate when reviewing sensitive operation, impact sink, privilege.

## Investigation Method

1. Classify the vulnerable function capability: memory corruption (RCE potential), injection sinks, auth decisions, data access, resource consumption.
2. Assess what the path can actually reach: does the attacker-controlled input reach the sensitive operation?
3. Determine privilege context: unauthenticated vs authenticated vs admin-only reachability.
4. Estimate exploitation requirements from the CVE (complexity, interaction) combined with the local path.
5. Output the impact claim tied to the sensitive operation, not the CVE generic description.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Sensitive-operation chain: path, capability, privilege context, with the impact claim bounded by it.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Generic CVE impact copied without local path grounding.

## Impact

Impact overstated (copy-paste CVSS narrative) or understated.

## Remediation

Path-grounded impact statements, privilege-context labels, exploitability requirements.

## Regression Test

Impact-chain fixtures asserting correct capability classification.

## False Positives

Sensitive operation present but not reachable via the vulnerable path - keep classification per path.

## Related Skills

- cve-reachability-engine.md
- input-source-analysis.md

## References

- CWE capability taxonomy
