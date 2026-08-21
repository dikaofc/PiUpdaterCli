---
name: ruby-gemfile-check
description: Audit Gemfile dependencies for outdated gems and enforce version pinning.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a Ruby project with Bundler and the `bundle` binary available.
metadata:
  category: review
  tags: [ruby, bundler, gemfile, dependencies, gems]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Ruby Gemfile Check

## Objective
Audit a Ruby project's Gemfile for dependency health: security advisories (`bundle audit`), outdated gems (`bundle outdated`), and pinning discipline. Every gem on the critical path is pinned to a resolvable, non-floating version; upgrades are executed one gem at a time with a `cap risk` rationale and a full test run between steps.

## Preconditions
- `Gemfile` and `Gemfile.lock` exist; `cap repo` identifies the Ruby project root.
- `bundle`/`ruby` are available, and the bundle can install or at least resolve offline (a vendor/cache or frozen lock).
- Baseline `cap test` and `cap diff` are captured before any gem change.

## Workflow
1. Run `cap status` and `cap repo` to confirm layout; read the Gemfile with `cap show Gemfile` for version constraints and groups (development/test/production).
2. Verify integrity: `bundle check` and `bundle lock` in dry mode to confirm the lock matches the Gemfile.
3. Run `bundle audit check --update` (needs network) for security advisories and `bundle outdated --strict` for drift; record findings via `cap memory add` with package names and versions.
4. Classify each outdated/advisory gem with `cap risk`: whether it is direct or a transitive dep, its place on the boot path, and the jump size of the fix version.
5. Upgrade one gem at a time: `bundle update <gem> --conservative` to avoid dragging unrelated gems, re-running `bundle check` and `cap test` after each; never `bundle update` the whole set in one step.
6. Enforce pinning: record floating constraints found via `cap search "gem ['\"][^'\"]+['\"](,? *['\"][>~][^'\"]*['\"]){0,2}$"` and tighten `>= x`/`~>` lines to matching `= x` pins where policy demands; keep `!=` exclusions only when a known break forces them (with a comment).
7. After each change run `cap test` and `cap lint`; a bump that breaks the suite is reverted with `cap rollback --task <id>` and re-triaged.
8. Run `cap verify` and `cap diff` to confirm only Gemfile/Gemfile.lock changes.
9. Record the durable facts (`cap memory add`): Ruby/Bundler versions and the pinning policy applied.

## Verification
- [ ] `bundle check` passes (frozen lock intact); `bundle lock` produces no further diff.
- [ ] `bundle audit` reports zero unaddressed advisories in scope, or each deferral has a documented `cap risk` reason.
- [ ] No floating constraints remain on critical-path gems except documented exclusions.
- [ ] `cap test`/`cap lint`/`cap verify` green; baseline test counts preserved.
- [ ] `cap diff` shows only Gemfile/Gemfile.lock (and incidental CI/doc) changes.

## Failure Handling
- Advisory without a patched release: report the advisory ID/source, pin to the last safe version range, and defer with a written reason; never edit Gemfile.lock by hand to remove the advisory entry (review-only rules force a documented plan first).
- An upgrade drags unrelated gems (resolution ripple): revert with `cap rollback --task <id>` and retry with `--conservative` plus explicit source constraints; if the ripple is irreducible, upgrade the affected group together with one `cap risk` entry.
- Network unavailable: run `bundle outdated --local` and report `bundle audit` as blocked with the exact re-run command; deliver the pinning audit only.
- A pinned version conflicts with production availability: stop and flag the environment; do not relax the pin without approval.

## Output Format
Final report:
- `bundle check`/`bundle audit`/`bundle outdated` result tables (guard: current → fixed).
- Pinning changes: constraints tightened, exclusions kept with reasons.
- Upgrades applied one-per-step with `cap risk` rationale; any ripples or reverts.
- `cap test`/`cap lint`/`cap verify` results and the final `cap diff` summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap risk`, `cap test`, `cap lint`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.