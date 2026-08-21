---
name: dependency-security
description: Audit and secure dependencies — vulnerability scanners, version pinning, lockfiles, license compliance, supply chain.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dependency Security

## Baseline
- **Lockfiles committed** (package-lock/pnpm-lock/Cargo.lock/uv.lock) — reproducible + hash-pinned installs; `npm ci` in CI.
- Version pinning: exact versions in lock; major bumps via deliberate upgrade PR (never silent range drift).
- Scanners in CI: `npm audit`/`pnpm audit`, `pip-audit`, `cargo audit`, `govulncheck`, `osv-scanner` — fail on critical/high; review + upgrade within SLA (critical 7d).

## Runtime hygiene
- Prune: `npm prune`/`pip uninstall`/`cargo machete` for unused deps — smaller attack + supply risk surface (`dependency-audit` skill).
- No `--save` of dev-only into prod (`--save-dev`); `omit=dev` in prod install (discarding build tools/browser libs).
- Production images exclude dev deps + build caches (`docker-containers`).

## Supply chain (the sneaky part)
- Signatures: `npm` integrity hashes in lock; verify checksums on binary downloads (sha256 + signature where provider offers).
- Unknown/provenance: audit new deps' maintainership/publish history; watch for typosquats (`express-s` vs `express`) and name-soup high-install-count camouflage.
- Registry scope: private registry + feed blocking `.npmrc` when exposure matters; `--registry` pinned.
- Renovate/Dependabot PR drills: upgrade cycles prevent "expired-everything" sprint.

## CVE review discipline
- Info ≠ action: read the CVE from a trusted source, map it to *this* codebase's reachability (not only severity score). False-confidence trap: "scanner green" doesn't mean clean — backfilled `cvssScore` ≠ exploitability.
- Track a **known-vulnerability register** for accepted risks (id, part, mitigations, expiry) — 4-eyes approval for deferrals.
- Rebuild cadence: lock churn monthly; monthly `pnpm audit` full + quarterly OSV runtime scan.

## Checklist
- [ ] Lockfiles + ci installs; no silent ranges
- [ ] Scan wired + failing on high/critical
- [ ] Dev deps not shipped to prod
- [ ] Signatures/checksums verified
- [ ] Known-vuln register for deferrals