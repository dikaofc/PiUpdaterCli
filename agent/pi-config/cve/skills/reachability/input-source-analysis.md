# Skill: Input Source Analysis

## Purpose

Identify whether attacker-influenceable input can reach the vulnerable function (taint path analysis).

## Trigger Conditions

Activate when reviewing input source, attacker input, taint.

## Investigation Method

1. Enumerate input sources: HTTP request data (params, headers, bodies, files), messages (queues, webhooks), deserialized data, environment, config files, external APIs.
2. Trace data flow from sources through the project into the vulnerable function parameters.
3. Assess influence: fully attacker-controlled, partially controlled (constrained validation), or uncontrolled.
4. Note validation/transformation stages that may break the taint path (and whether they are effective).
5. Verdict per path: attacker-reachable, constrained, or not attacker-reachable.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Taint-path trace: source to transformations to sink (vulnerable function) with control assessment.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Reachability asserted without an input source that can drive the path.

## Impact

Exploitability over- or under-stated.

## Remediation

Taint-path evidence per candidate; source inventory; validation-effectiveness checks.

## Regression Test

Taint fixtures asserting source-to-sink detection with validation breaks.

## False Positives

Sources that are server-internal only (no attacker influence) - classify as reachable-but-not-attacker-controlled.

## Related Skills

- cve-reachability-engine.md
- execution-path-analysis.md

## References

- taint analysis (CodeQL), OWASP input source taxonomy
