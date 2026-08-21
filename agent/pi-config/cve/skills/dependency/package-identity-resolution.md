# Skill: Package Identity Resolution

## Purpose

Resolve package identity aliases (name case, scopes, registries, renamed packages) to a canonical key for reliable matching.

## Trigger Conditions

Activate when reviewing alias, canonical name, case, scopes.

## Investigation Method

1. Define canonicalization per ecosystem: npm lowercasing, PyPI normalization (PEP 503), Maven groupId:artifactId case rules, NuGet case-insensitivity, Go module paths (case-sensitive!), crates exact names, RubyGems case rules.
2. Build an alias table for known renames and forked/mirrored packages (with provenance).
3. Ensure advisory matching uses the canonical key for both sides (advisory package names are also canonicalized).
4. Flag mismatches: an advisory naming a package that maps to multiple local identities is a review item.
5. Never merge two distinct packages silently (e.g., different namespaces).

## Evidence Requirements

Required before classifying a CVE as applicable or reporting a CVE finding:

A canonical-identity table with alias entries and test cases per normalization rule.

Evidence and confidence follow the levels defined in `context/evidence-model.md` and
`context/confidence-model.md`. A CVE existence in a lockfile is static evidence (E1) only;
applicability requires behavioral or structural evidence (E3+) such as reachable call paths
or proven configuration.

## Defensive Boundary

All CVE analysis in this library is defensive and evidence-based. The agent may: identify vulnerable dependencies and versions, explain vulnerability mechanics at a high level, inspect source code, reproduce bugs in isolated test environments (local fixtures, mocks, sandboxes you control), write regression tests, recommend patches, compare vulnerable vs fixed versions, and verify remediation. It must NOT perform live exploitation of third-party systems, exfiltrate data, or turn CVE intelligence into an attack playbook. Use local or cached data when offline; prefer UNKNOWN over fabricated information.

## Root Cause Analysis

Case/scope-insensitive matching across all ecosystems breaks Go/crates and merges distinct packages.

## Impact

False matches and missed matches in CVE correlation.

## Remediation

Per-ecosystem canonicalization, explicit alias table, identity conflict review.

## Regression Test

Identity test fixtures asserting exact alias resolution per ecosystem.

## False Positives

Similar-named packages (typosquatting-risk reads) — keep distinct unless officially renamed.

## Related Skills

- ecosystem-registry-map.md
- cve-package-correlation.md
- duplicate-detection.md

## References

- PEP 503
- npm package-name rules
