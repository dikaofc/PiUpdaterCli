# Workflow: Dependency Audit

## Purpose

Audit the dependency set and supply chain: known vulnerabilities, outdated
packages, integrity, lockfile correctness, and dependency-confusion risk — always
with reachability analysis so only real risk is reported.

## Method

### 1. Inventory

- Collect manifests and lockfiles for every language in the project
  (`dependency-discovery.md`).
- Build the full tree including transitive dependencies (`transitive-dependencies.md`).
- Identify native/system dependencies (`native-dependency-analysis.md`).

### 2. Known Vulnerabilities

- Cross-reference against advisories (OSV, GitHub Advisory DB, vendor advisories,
  OS package trackers). Check: installed version in range? vulnerable component
  included? (see `../context/dependency-model.md` reachability ladder).

### 3. Integrity & Supply Chain

- Lockfile pins and integrity hashes verified? (`lockfile-analysis.md`,
  `package-integrity.md`).
- Internal vs public package naming — dependency confusion risk
  (`dependency-confusion.md`).
- Registry/CI provenance and artifact verification
  (`supply-chain/supply-chain-risk.md`).

### 4. Outdatedness

- Outdated but not vulnerable: note as INFORMATIONAL with upgrade rationale.
- Deprecated/unmaintained packages: supply-chain risk
  (`outdated-dependency-analysis.md`).

### 5. Reachability

For each reportable advisory, run the reachability ladder
(`../context/dependency-model.md`): installed → included → used → reachable →
unmitigated → exploitable. Report only what survives.

### 6. Remediation

- Prefer minimal version bumps; assess breaking changes and regression risk.
- Add/adjust regression tests around the upgraded behavior.
- Propose lockfile hygiene fixes (pinning, hashes) as MEDIUM/LOW where applicable.

### 7. Report

Per `../templates/audit-summary.md` with a dependency table: package, version,
advisory, reachable?, severity, remediation, status.

## Rules

- Never report "package X has CVE Y" as automatically exploitable
  (`../METHODOLOGY.md` Dependency Analysis).
- Never invent CVEs; verify against primary advisory sources.

## Related

- `../skills/dependencies/*`, `../skills/supply-chain/*`
- `../checklists/dependency.md`
- `../context/dependency-model.md`
