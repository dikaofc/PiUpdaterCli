---
name: dependency-audit
description: Audit project dependencies — unused, outdated, license, and vulnerability status — across common package manifests and lockfiles.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a repository containing any supported manifest (package.json, pnpm-lock, package-lock, yarn.lock, requirements.txt, pyproject.toml, Cargo.toml, go.mod, pom.xml, build.gradle, composer.json).
metadata:
  category: dependency
  tags: [dependencies, audit, license, vulnerability]
---

# D
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ependency Audit

## Objective
Produce a per-dependency audit report covering: declared dependencies (from manifests
and lockfiles), **unused** dependencies, **outdated** versions, **license** information,
and known **vulnerabilities** — with every claim tied to manifest lines and code
evidence.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- At least one supported manifest/lockfile exists and is readable (`cap show`).
- Network access to package registries is available when checking latest versions and CVEs (if offline, that check is marked unverified).

## Workflow
1. Run `cap status`, then `cap repo` to detect which manifests exist (package.json, pnpm-lock.yaml, package-lock.json, yarn.lock, requirements.txt, pyproject.toml, Cargo.toml, go.mod, pom.xml, build.gradle, composer.json).
2. Read each manifest and each lockfile with `cap show <file>` (with line numbers) and record the declared dependencies, resolved versions (manifest vs. lockfile), and license fields. Build the canonical dependency list from the most specific lockfile and cross-check against the manifest.
3. **Unused dependencies**: for each declared dependency, run `cap search <import-pattern>` (e.g., the module/package name) across source files, and `cap explore <symbol>` for symbol-level usage; a dependency with zero source references is a candidate for unused. Note config-only and build-tool usages to avoid false positives.
4. **Outdated dependencies**: compare the resolved version in the lockfile against the latest available version from the registry (via registry API or `cap`-provided checks); flag outdated ones, and separately flag major-version gaps as higher risk. If the registry is unreachable, mark this check as unverified.
5. **Licenses**: extract each dependency's license from the manifest/lockfile metadata; flag missing, unknown, and copyleft/restrictive licenses for review. Do not invent a license for a package that does not declare one.
6. **Vulnerabilities**: cross-check resolved versions against known vulnerability data (registry audit endpoints or an equivalent source); for each hit, record the affected range, the fixed version, and the advisory identifier. If the data source is unavailable, say so.
7. Check for duplicate/conflicting versions and stale lockfiles (manifest and lockfile disagree) via `cap diff` of the two files and `cap search` for version strings.
8. Run `cap rules check` on the manifest files if the project defines dependency rules, and note violations.
9. Compile the report and record durable findings with `cap memory add` (e.g., policy decisions on upgrades).

## Verification
- [ ] Every dependency listed in the report appears in a manifest/lockfile line (cited).
- [ ] "Unused" claims verified by absence of references in `cap search`/`cap explore` results, with obvious false-positive patterns (config, scripts) checked.
- [ ] "Outdated" and "vulnerability" claims carry the versions compared and the data source.
- [ ] License claims come from the manifest/lockfile, or are explicitly marked unknown.
- [ ] Offline/unavailable checks are marked unverified, not reported as facts.
- [ ] The report distinguishes declared, resolved, and latest versions per dependency.
- [ ] Duplicate/conflicting versions and stale lockfiles (manifest vs. lockfile) were checked.

## Failure Handling
- If a registry is unreachable: complete the static parts (unused, lockfile consistency) and mark version/vulnerability sections as unverified with the reason.
- If a package is referenced only via dynamic import or build config: check `cap search` with several patterns before marking it unused; when still ambiguous, mark it "possible unused".
- If the manifest is inconsistent with the lockfile: report it as a finding and recommend regenerating the lockfile, rather than guessing which is correct.
- If a dependency is used only in tests or dev tooling, classify it accordingly (dev vs. prod) instead of calling it unused.

## Output Format
Final report:
- Manifests analyzed (paths).
- Summary counts: total deps, unused, outdated, licenses needing review, vulnerabilities.
- Findings table per dependency: name, declared version, resolved version, latest, unused?, license, vulnerability status (advisory + fix), evidence (manifest line / search result).
- Recommended actions (remove, pin, upgrade, review license) with priorities.
- Verification notes (data sources used; what is unverified).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap show`, `cap search`, `cap explore`, `cap diff`, `cap rules check`, `cap memory`.
- CONTRACT.md §1: `cap repo` manifest detection semantics for supported lockfiles.
