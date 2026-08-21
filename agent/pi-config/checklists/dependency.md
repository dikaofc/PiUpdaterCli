# Checklist: Dependency

Verification checklist for dependencies and supply chain.

## Inventory

- [ ] Manifests and lockfiles present and in sync
  (`lockfile-analysis.md`)
- [ ] Lockfiles pinned with integrity hashes (`package-integrity.md`)
- [ ] Transitive dependency tree understood (`transitive-dependencies.md`)
- [ ] Native/system dependencies inventoried (`native-dependency-analysis.md`)

## Vulnerabilities

- [ ] Advisories checked (OSV, GitHub Advisory, vendor) against installed versions
- [ ] Reachability analysis done for every advisory
  (`../context/dependency-model.md`)
- [ ] No unpatched reachable CRITICAL/HIGH advisories
- [ ] Outdated-but-safe packages tracked (`outdated-dependency-analysis.md`)

## Supply Chain

- [ ] Dependency confusion risk checked (internal vs public names)
  (`dependency-confusion.md`)
- [ ] Registry/CI fetch pinned and verified (`supply-chain-risk.md`)
- [ ] No suspicious install scripts or modified packages

## Related

- `../workflows/dependency-audit.md`
- `../skills/dependencies/*`, `../skills/supply-chain/*`
