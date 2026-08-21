---
name: tech-debt-report
description: Catalog technical debt — file-level evidence, priority, and remediation bounds per item.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: architecture
  tags: [tech-debt, catalog, priority, maintenance]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Tech Debt Report

## Objective
Produce a catalog of technical debt in a scope (module, service, or repo): each item
identifies the file, concrete evidence (line-level smell or metric), a priority, and
a bound for the remediation (what fix is allowed, what is out of scope). The result
is an actionable list a maintainer can schedule, not an essay.

## Preconditions
- Repository is indexed (`cap index --refresh`) so greps and symbol resolution are fast and accurate.
- The scope is named; findings are confined to it unless the user widens the scope.

## Workflow
1. Run `cap status` and `cap repo` to baseline: branch, dirty state, and language facts.
2. Run the evidence sweep over the scope, in parallel greps:
   - Duplication: `cap search` for repeated blocks (same 5+ line pattern), `cap explore` for copy-pasted helpers.
   - Dead code: `cap search "export \w+"` then `cap explore <symbol>` for zero references.
   - Legacy/blocked upgrades: `cap search "TODO|FIXME|HACK|deprecated"`, `cap explore "legacy|migration"`.
   - Reliability risks: `cap search "any|@ts-ignore|eslint-disable"` and `cap search "catch *\(.*\) *\{\s*\}"` (swallowed errors).
   - Coupling/architecture: `cap explore` for high-fan-in modules; `cap search "import.*(utils|shared)"` for shotgun imports.
3. Read each candidate with `cap show <file> [--lines a-b]` and keep only items with concrete evidence — smells without a line are dropped.
4. Classify each item:
   - DEBT-PATTERN — duplicated/misnamed code that still works.
   - DEAD-WEIGHT — unused exports/branches (verify with `cap explore`).
   - BLOCKED-UPGRADE — pinned dependency or shim (`cap search "skipLibCheck|overrides"`).
   - FRAGILE — `@ts-ignore`/`any`/swallowed errors on hot paths.
   - ARCHITECTURE — coupling hot spots.
5. Run `cap risk --json` signals and rank: P0 = on hot path + user-facing failure mode; P1 = blocks a roadmap item; P2 = cosmetic/maintainability.
6. For each item set the remediation bound: the minimal allowed fix (rename, dedupe target, upgrade step) and the explicit out-of-scope (rewrites, new deps, behavior change) — bounds keep later fixes honest.
7. Estimate cost per item: lines affected (`cap show` count), files to touch (`cap explore` reverse references).
8. Write the report: table (rank, file, item, evidence, cost, bound) + backlog section for P2/P3.
9. Optionally convert the top item into a real task: `cap plan "<remediation of P0>"` and save it via `cap memory add` (planned, not executed).
10. `cap rollback` does not apply here (report-only skill); close by storing the catalog in memory so future sessions can check items off.

## Verification
- [ ] Every item has file:line (or symbol-level) evidence from `cap show`/`cap explore`; nothing from impression.
- [ ] Zero-reference claims verified via `cap explore` before marking DEAD-WEIGHT.
- [ ] Every P0/P1 item has a remediation bound (allowed fix + out-of-scope).
- [ ] Cost estimates derive from counted lines/files, not guesses.
- [ ] Report-only: no source files modified (`cap diff` clean).
- [ ] Catalog stored via `cap memory add` for follow-up.

## Failure Handling
- If a smell cannot be localized to a line (e.g., architectural drift visible only at module level): keep it as a scope-level finding with the coupling evidence, not a fake line number.
- If `cap explore` shows a seeming dead export IS referenced (dynamic import, string-based): downgrade or drop the item — never report verified-doubtful debt.
- If prioritization is ambiguous (two P0 candidates): run `cap risk --json` on each changed-area proxy or ask the user — never flip a coin silently.

## Output Format
- Debt table: rank (P0/P1/P2) | file | item type (DEBT-PATTERN/DEAD-WEIGHT/BLOCKED-UPGRADE/FRAGILE/ARCHITECTURE) | evidence (file:line) | cost (lines × files) | remediation bound (allowed | out-of-scope).
- Backlog section (P2/P3) in one-liners.
- Recommended first task (P0) with `cap plan` reference.
- Confirmation: `cap diff` clean, catalog stored.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap explore`, `cap show`, `cap risk`, `cap plan`.
- CONTRACT.md §4 Severity/risk categories reused for priority ranking.