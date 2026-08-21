# Skill: Dependency Graph Build

## Purpose

Build the resolved dependency graph (nodes = packages+versions, edges = dependency relations) used by CVE correlation and reachability.

## Trigger Conditions

Activate when reviewing graph, closure, edges, via.

## Investigation Method

1. Parse the lockfile graph into nodes (canonical package+version) and edges (consumer → dependency, incl. dev/optional/peer labels).
2. Resolve deduplication: hoisting, mediation, MVS — the graph must reflect the effective resolved set.
3. Annotate each node: direct/transitive, via-chain (path from root), node_modules path semantics.
4. Compute per-node metadata: outgoing edges (its deps), incoming edges (who depends on it) for remediation targeting.
5. Validate the graph against the publisher/lockfile resolver on a controlled sample.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A resolvable graph artifact (JSON) with node/edge counts and spot-checked via-chains matching the lockfile.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Graph built from manifests (ranges) instead of lockfiles (resolved versions).

## Impact

Reachability and remediation decisions based on an unreal resolution.

## Remediation

Lockfile-driven graph construction, platform verification, graph versioning.

## Regression Test

Fixture lockfiles asserting exact node/edge sets.

## False Positives

Workspace-monorepo confusion — resolve per-workspace subgraphs correctly.

## Related Skills

- cve-transitive-dependency-analysis.md
- cve-runtime-dependency-analysis.md

## References

- package-lock structure
- pnpm workspace semantics
- Maven dependency tree
