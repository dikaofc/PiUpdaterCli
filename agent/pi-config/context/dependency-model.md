# Dependency Model

A vulnerable dependency is not automatically a vulnerability in the application.
This model defines the reachability analysis every dependency finding must pass.

## The Reachability Ladder

1. **Installed** — is the package actually in the dependency set (manifest +
   lockfile)? (`skills/dependencies/dependency-audit.md`)
2. **Included** — is the vulnerable component actually bundled into the artifact
   (tree-shaken out, optional dependency, platform-specific)?
3. **Used** — is the affected functionality imported/called anywhere in the
   application or its active transitive tree?
4. **Reachable** — can an attacker (or untrusted input) reach the vulnerable code
   path at runtime? (`skills/static-analysis/call-graph-analysis.md`)
5. **Unmitigated** — does configuration, WAF, sandboxing, or platform behavior
   prevent the exploitation?
6. **Exploitable impact** — does the reachable path produce meaningful impact in
   this deployment?

A finding is only reportable above the reachable/unmitigated threshold; below that,
record as LOW or INFORMATIONAL with the reasoning.

## What to Inspect

- Manifest + lockfile consistency: lockfile pinned versions, integrity hashes
  (`skills/dependencies/lockfile-analysis.md`).
- Transitive dependencies: who pulls the vulnerable package, and at what version
  (`skills/dependencies/transitive-dependencies.md`).
- Dependency confusion risk: internal package names vs public registry
  (`skills/dependencies/dependency-confusion.md`).
- Native components: C/C++/Rust/Go libraries, system packages
  (`skills/dependencies/native-dependency-analysis.md`).
- Supply chain: registry provenance, CI fetching, artifact integrity
  (`skills/supply-chain/supply-chain-risk.md`).

## Rating Guidance

- Installed + included + used + reachable + exploitable → rate by real impact.
- Installed + included + used but NOT reachable from untrusted input → MEDIUM at
  most; document the reachability gap.
- Installed but not used/included → LOW or INFORMATIONAL.
- Not installed (false alarm from a generic advisory list) → FALSE POSITIVE.

## Patch & Regression Risk

Before recommending an upgrade, assess regression risk: major version changes,
breaking API usage, behavior changes (e.g., parser strictness), and the test
coverage that would catch regressions (`skills/testing/regression-testing.md`).

## Related

- `../workflows/dependency-audit.md`
- `../skills/dependencies/dependency-audit.md`
- `../skills/supply-chain/supply-chain-risk.md`
- `../skills/static-analysis/call-graph-analysis.md`
- `../context/false-positive-model.md`
