---
name: npm-housekeeping
description: Audit npm dependencies for duplicates, dangling and unused packages, lockfile drift, and correct install workflow.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); relies on `cap repo` and `cap verify` for project checks.
metadata:
  category: review
  tags: [npm, dependencies, lockfile, audit]
---

# npm Housekeeping
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Audit the npm dependency graph: dangling/unused packages, duplicate versions, lockfile drift between `package.json` and lockfile, `npm ci` vs `npm install` fitness, and shrinkwrap presence. Report findings with severity and exact remediation commands; fix only with user approval.

## Preconditions
- Manifest and lockfile paths located (`package.json`, `package-lock.json` / `npm-shrinkwrap.json` / `yarn.lock` / `pnpm-lock.yaml` via `cap search` or known).
- The repository toolchain works (`cap repo` confirms detected package manager).
- The audit can run `npm` commands read-only (`npm ls`, `npm outdated`, `npm dedupe --dry-run`); no installs happen without approval.

## Workflow
1. Run `cap status` and `cap repo` to confirm repo type and package manager; record manifest and lockfile versions.
2. Read `package.json` (`cap show`) and record: dependencies, devDependencies, peerDependencies, optionalDependencies, engines, and packageManager field.
3. Detect dangling dependencies: run `npm ls --depth=0` and `npm ls` for error output (`extraneous`, `invalid`, `missing`); cross-check declared deps against imports found with `cap search <package-import>` for unused status (dep listed but never imported).
4. Detect duplicates: `npm ls <pkg>` for each suspected duplicate or use `npm ls --all` filtered; record packages at multiple versions with their location and fix suggestion (`npm dedupe`).
5. Lockfile drift: compare `package.json` declared ranges vs resolved versions in the lockfile; if the lockfile is missing, out of sync, or `package-lock.json` differs from `npm install` output, report with the reconciliation command (`npm install` vs `npm ci`).
6. Shrinkwrap: check for `npm-shrinkwrap.json` presence; if deploying from the repo, recommend `npm ci` (requires lockfile) over `npm install`.
7. Vulnerability scan: if configured, run `npm audit` (or `cap risk` for repo risk) and record high/critical counts with remediation commands (`npm audit fix` — never `--force` without approval).
8. If fixes are approved, apply the smallest set (dedupe, remove unused via `npm uninstall`, regenerate lockfile), then run `npm ci` to prove a clean install, and `cap verify` for the full pipeline.
9. Record durable decisions (package manager choice, ci-first rule) with `cap memory add`.

## Verification
- [ ] Manifest and lockfile facts recorded (format, versions, drift status).
- [ ] Dangling/unused inventory: every suspect cross-checked against import scan.
- [ ] Duplicate report lists package, versions, locations, and dedupe suggestion.
- [ ] Lockfile drift classification explicit (in-sync / missing / out-of-sync) with reconciliation command.
- [ ] `npm ci` (or equivalent) run successfully when fixes were applied.
- [ ] `cap verify` passes after any change; `npm audit` results reported if run.

## Failure Handling
- If `npm ls` reports errors (`extraneous`): stop the rest of the audit until reported, since the tree state is unreliable for duplicates.
- If `npm ci` fails due to lockfile drift: report the mismatch contents, do not regenerate the lockfile automatically — get approval first.
- If `npm audit` returns criticals: never run `npm audit fix --force`; list the offending packages and let the user decide.
- If no lockfile exists at all: flag as an install-reproducibility risk and recommend generating one with user approval.

## Output Format
Final report:
- Package-manager and lockfile facts.
- Findings: dangling, unused, duplicate, drift, shrinkwrap — each with severity and exact remediation command.
- Audit results (npm audit) with counts, if run.
- Changes applied (with approval) and `npm ci` + `cap verify` results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap risk`, `cap verify`, `cap memory add`.