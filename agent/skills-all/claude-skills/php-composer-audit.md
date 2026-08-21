---
name: php-composer-audit
description: Audit Composer dependencies, platform requirements, and security advisories.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a PHP project managed by Composer with the `composer` binary available.
metadata:
  category: review
  tags: [php, composer, dependencies, security, audit]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# PHP Composer Audit

## Objective
Audit a Composer-managed PHP project's dependency health: lockfile consistency with `composer.json`, platform requirement compatibility (PHP version and ext-* extensions), and known security advisories via `composer audit`. The output is a triaged remediation list — critical advisories and platform breaks first — with each fix scoped to its package via `composer require/downgrade`.

## Preconditions
- `composer.json` and `composer.lock` exist; `cap repo` identifies the PHP project root.
- The `composer` binary is available (or the platform is able to run PHP/Composer).
- Baseline test suite and `cap diff` are captured before any dependency change.

## Workflow
1. Run `cap status` and `cap repo` to confirm the project layout; read `composer.json` with `cap show` for require blocks and platform config.
2. Establish integrity: `composer validate --strict` for schema/platform warnings, and `composer install --dry-run` to confirm lockfile consistency.
3. Run `composer audit` (security advisories, requires a cooperative network) and record every finding with `cap memory add`; capture the `--no-interaction` output verbatim in the report.
4. List drift: `composer outdated` grouped as direct/indirect, and cross-check each outdated candidate's risk with `cap risk` before proposing a bump.
5. For each advisory: read the affected package's lock entry with `cap show composer.lock`-derived version, map the fix version via `composer audit` output, and upgrade the single package (`composer require <pkg>:^<fix>`); never `composer update` the whole tree in one step.
6. Check platform requirements explicitly: `composer check-platform-reqs`; a missing `ext-*` or a too-new PHP floor is a deploy break, not a lint warning.
7. After each dependency change, run `cap test` and `cap lint`; a package bump that breaks the suite is reverted via `cap rollback --task <id>` and re-triaged.
8. Run `cap verify` and `cap diff` to confirm only `composer.json`/`composer.lock` and incidental code changes.
9. Record durable facts (`cap memory add`): the PHP floor, ext requirements, and the upgrade policy used.

## Verification
- [ ] `composer validate --strict` passes with no platform/schema errors.
- [ ] `composer audit` reports zero unfixed advisories in the affected scope, or every remaining one has a documented `cap risk` deferral.
- [ ] `composer check-platform-reqs` passes for the locked PHP version and extension set.
- [ ] `composer install --dry-run` and `composer install --lock` agree — lockfile and manifest are in sync.
- [ ] `cap test`/`cap lint`/`cap verify` green; `cap diff` shows only dependency-manifest changes.

## Failure Handling
- Advisory has no fix release: report with the CVE/source reference, propose a temporary pin-down or workaround, and mark the risk as deferred — never mask the advisory via `--no-scripts` or by editing the lock by hand.
- A bump breaks the test suite: `cap rollback --task <id>` the manifest/lock, keep the previous version, and record the incompatibility; do not leave composer.lock dirty.
- Network unavailable for `composer audit`: run `composer validate`/`check-platform-reqs` (offline-safe) and report the audit as blocked with the exact command to re-run.
- Ext-extension missing: report the required `ext-*` and the install command for the deployment target; do not change code to dodge the requirement.

## Output Format
Final report:
- `composer validate`/`check-platform-reqs` results; PHP floor and ext requirements recorded.
- Advisory table: package, affected version, fixed version, action taken (upgraded/deferred), CVE source.
- Outdated list with `cap risk` classification; packages bumped with old → new.
- `cap test`/`cap lint`/`cap verify` results and the final `cap diff` summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap risk`, `cap test`, `cap lint`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.