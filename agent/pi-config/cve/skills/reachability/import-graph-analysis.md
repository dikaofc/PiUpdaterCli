# Skill: Import Graph Analysis

## Purpose

Analyze which project modules import the vulnerable dependency and its vulnerable entry points.

## Trigger Conditions

Activate when reviewing imports, module resolution, require.

## Investigation Method

1. Resolve imports/requires of the package: static (import x from "pkg"), dynamic (require("pkg/subpath")), and transitive imports.
2. Map each import site to the dependency module/entry point, including subpath imports.
3. Determine which imported subpath corresponds to the vulnerable functionality.
4. Record the import sites as reachability entry candidates.
5. Handle module bundling (webpack, esbuild) - the imported bundle may tree-shake or include the vulnerable code.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

Import-site list with module/subpath resolution and tree-shaking/bundling notes.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Package presence used as proxy for "imported".

## Impact

Reachability claims without import evidence.

## Remediation

Real import resolution, subpath awareness, bundler-aware analysis.

## Regression Test

Fixture import graphs asserting detected import sites.

## False Positives

Dead code paths where an import exists but is never called (import does not equal call; call graph decides).

## Related Skills

- cve-reachability-engine.md
- call-graph-analysis.md

## References

- module resolution docs (node, webpack)
