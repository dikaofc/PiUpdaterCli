# Skill: Ecosystem Registry Map

## Purpose

Maintain the canonical map of package ecosystems → registries → advisory sources, extensible to any ecosystem.

## Trigger Conditions

Activate when reviewing ecosystem, registry, npm, pypi, maven, nuget, go, cargo, rubygems, composer, pub, hex, alpine, debian, rpm.

## Investigation Method

1. Record each supported ecosystem with: package manager, manifest/lockfile formats, canonical registry, version scheme, and primary advisory sources.
2. Cover the baseline set: npm, PyPI, Maven, Gradle, NuGet, Go modules, Cargo, RubyGems, Composer, CocoaPods, SwiftPM, pub.dev, Hex, Alpine, Debian, Ubuntu, Fedora, Arch, RPM, DEB, Homebrew, Docker/OCI images.
3. Document per-ecosystem peculiarities: scope/namespace rules (npm @scope, Go module paths, Maven groupId:artifactId), version equality rules, backport behavior.
4. Define the extension mechanism: a registry entry = ecosystem key + parsers + normalizers + advisory source config; adding a new ecosystem is configuration, not restructuring.
5. Keep advisory-source priorities per ecosystem (distro-first for OS ecosystems, upstream-first for language ecosystems).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

The registry map rendered as a table with per-ecosystem parsers/normalizers/sources, and one documented example of adding a new ecosystem end-to-end.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Ecosystem-specific semantics hardcoded per source or ecosystem left undocumented.

## Impact

Wrong parsing/normalization for less-common ecosystems; inability to extend.

## Remediation

Configuration-driven ecosystem registry, per-ecosystem test vectors, documented extension path.

## Regression Test

Ecosystem vector tests (version ordering, name normalization) per registered ecosystem.

## False Positives

Ecosystems the project does not use — the map is capability, not an assertion of usage.

## Related Skills

- language-ecosystem-map.md
- version-normalization.md
- cve-package-correlation.md

## References

- registry docs (npm, PyPI, Maven Central, NuGet, crates.io, rubygems, pub.dev, hex.pm)
