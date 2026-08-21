# Skill: Language Ecosystem Map

## Purpose

Map programming languages → ecosystems → package managers → packages → vulnerable versions → CVE/advisory, for correlation and queries.

## Trigger Conditions

Activate when reviewing language, ecosystem, package manager, mapping.

## Investigation Method

1. Define the language layers: JavaScript/TypeScript → npm/pnpm/yarn/bun; Python → pip/poetry/uv/PyPI; Go → go modules; Rust → cargo/crates.io; Java/Kotlin → Maven/Gradle; C#/F# → NuGet; PHP → composer/Packagist; Ruby → bundler/RubyGems; Swift → SwiftPM; Dart → pub.dev; Erlang/Elixir → Hex; C/C++ → distro/vendored; Shell → package scripts + distro; SQL → no package ecosystem (DB drivers via language ecosystems).
2. For each (language, ecosystem) pair record: manifest detection, lockfile detection, resolver behavior, canonical package naming.
3. Build the query path: language → ecosystem → package manager → package → version → CVE/advisory (used by the conceptual search engine).
4. Check coverage conventions: any language not listed is still supportable by adding an ecosystem entry.
5. Store the map as data (not prose logic) so queries can programmatically traverse it.

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A traversable language→ecosystem→manager table with a sample end-to-end query path executed.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Language/ecosystem pairs assumed from file extensions alone.

## Impact

Correlation gaps (e.g., Kotlin resolved only via Maven, F# via NuGet, misdetected).

## Remediation

Declarative language map, detection rules per pair, query-traversal tooling.

## Regression Test

Detection tests for each language fixture (manifest/extension) asserting the mapped ecosystem.

## False Positives

Polyglot projects — map each component to its own ecosystem, not a single guess.

## Related Skills

- ecosystem-registry-map.md
- cve-search-engine.md
- cve-package-correlation.md

## References

- ecosystem docs
