---
name: dependency-vuln
description: Scan dependencies for known CVEs via audit tooling; prioritize fixes by severity; never downgrade without evidence.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an audit-capable package manager (npm/pnpm/yarn audit or OSV scanner) reachable by the environment.
metadata:
  category: security
  tags: [dependencies, cve, audit, supply-chain]
---

# Dependency V
<!-- built by @dikaacode (telegram) -->
ulnerability Scan

## Objective
Identify known vulnerabilities in direct and transitive dependencies using audit
tooling, map each advisory to the packages that pull it, triage by severity and
reachability, and drive upgrades in a priority order — without ever downgrading a
package unless evidence (a working build and green tests) proves it is the only safe
option.

## Preconditions
- A package manifest and lockfile exist (`package.json` + `package-lock.json` /
  `pnpm-lock.yaml` / `yarn.lock`); repository indexed (`cap index --refresh`).
- The package manager's audit endpoint is reachable; otherwise the scan is marked
  offline/unverified.

## Workflow
1. Run `cap status` and `cap repo` to detect the package manager; `cap index --refresh` the tree.
2. Run the audit tooling for facts: `npm audit --json`, `pnpm audit --json`, `yarn audit --json`, or an OSV scanner (e.g. `osv-scanner`) with `--json`; capture severity (critical/high/medium/low), vulnerable ranges, patched versions, and the pull chain (which direct dependency leads to a vulnerable transitive).
3. Correlate advisories with actual usage: `cap explore <package>` and `cap search` for imports of the vulnerable package to judge whether the vulnerable API is reachable from this codebase; an unreachable advisory drops priority, not severity.
4. Rank the fix queue: CRITICAL reachable > HIGH reachable > CRITICAL/ HIGH unreachable > MEDIUM; note breaking-change risk for major upgrades and confirm the patched version is within the declared semver range of the lockfile.
5. Apply upgrades one at a time via the package manager (`npm install <pkg>@<patched>`), then run `cap lint`, `cap typecheck`, `cap test`; finish with `cap verify` which must stay green after each upgrade. If a test or build breaks, fall back to the previous lockfile state with `cap rollback --task <id>` and re-assess.
6. If a package has no patched version and only a downgrade "works": record the evidence (build/test output) explicitly in the report and escalate — never silently downgrade. Document residual risk with `cap memory add`, including any suppress-with-evidence advisories.
7. Confirm scope with `cap diff` (lockfile + manifest changes only) and note total advisory delta before/after.

## Verification
- [ ] Audit ran with machine-readable output; full advisory list captured.
- [ ] Every advisory mapped to a pull chain and reachability verdict (reachable/unreachable).
- [ ] Queue ordered by severity x reachability; every applied upgrade passed `cap verify`.
- [ ] No downgrade without captured evidence of a green build/tests; none silent.
- [ ] `cap diff` shows manifests and lockfiles only.
- [ ] Final audit run shows the residual advisory list with rationale.

## Failure Handling
- If the audit endpoint is unreachable: mark the scan offline, state counts as unverified, and do not claim a clean bill.
- If an upgrade breaks the build: roll back via `cap rollback`, record the failing tool output, and pick the next candidate or escalate.
- If a vulnerable package is a test-only/dev dependency: keep severity, lower priority, and note the reduced blast radius — do not drop the advisory.
- If patched version is not semver-compatible: prefer the compatible-major fix; if none exists, escalate with the upgrade plan.

## Output Format
Report: audit source and date, advisory table (package, severity, range, patched
version, pull chain, reachability, classification of fix), upgrade queue with applied
results per step (`cap verify` status), downgrade evidence if any, residual
advisories, and `cap diff` summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap repo`, `cap explore`, `cap test`, `cap verify`, `cap rollback`, `cap diff`, `cap memory add`.
- docs/review-engine.md §5 severity calibration.