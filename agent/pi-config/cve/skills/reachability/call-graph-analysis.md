# Skill: Call Graph Analysis

## Purpose

Build and analyze the call graph from application entry points to the vulnerable function to prove reachable calls.

## Trigger Conditions

Activate when reviewing call graph, dataflow, entry point.

## Investigation Method

1. Construct the interprocedural call graph from application entry points (request handlers, event handlers, background jobs).
2. Trace paths from each entry to the vulnerable function in the dependency.
3. Use available tooling (CodeQL, Semgrep, language-specific analyses) plus manual tracing for high-risk paths.
4. Evaluate path conditions (guards, config) that may block execution.
5. Record the call paths as evidence: file, line, function chain.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Call paths (entry to vulnerable function) with file/line evidence per hop.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

No call-path evidence; name-similarity used instead.

## Impact

DIRECTLY_REACHABLE claimed without proof, or reachable paths missed.

## Remediation

Tool-assisted call graphs validated by manual review on the final path; condition evaluation.

## Regression Test

Call-graph fixtures with reachable/unreachable paths asserting detection.

## False Positives

Call chains through functions never invoked by any runtime entry (entry coverage matters).

## Related Skills

- cve-reachability-engine.md
- execution-path-analysis.md
- import-graph-analysis.md

## References

- CodeQL dataflow
- call graph construction
