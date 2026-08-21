---
name: java-gradle-check
description: Audit Gradle build cache efficiency and enforce dependency locking.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a Gradle project (Gradle >= 6.8 for dependency locking built-in, Gradle build cache available).
metadata:
  category: review
  tags: [java, gradle, build-cache, dependency-locking]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Java Gradle Check

## Objective
Audit a Gradle build for cache effectiveness and dependency reproducibility: confirm the build cache hit ratio is measured and improved where cheap, dependency versions are locked (`lockfiles` / `dependency locking`), and the build never silently relies on a dirty or partial cache. The report separates cache-optimization gains from lock-safety facts.

## Preconditions
- Gradle wrapper present (`./gradlew`), `cap repo` identifies the project root.
- Build cache is enabled in gradle.properties (`org.gradle.caching=true`) or the audit is allowed to recommend enabling it.
- Baseline `./gradlew build` (or the project's main task) is runnable in this environment.

## Workflow
1. Run `cap status` and `cap repo` to confirm the Gradle layout; read `gradle.properties` and `settings.gradle*` with `cap show` for cache and lock config.
2. Establish the baseline build: run the main build task with `--profile` and `--info`, capturing the cache hit/miss lines; record hit counts via `cap memory add`.
3. Inventory dynamic dependencies with `cap search "latest\.|SNAPSHOT|\\+\\}\\|\\+\\)|implementation .*:.*:[0-9]+\\.[0-9]+"` in build files; each dynamic version defeats locking and is a reproducibility risk.
4. Check lock state: `./gradlew dependencies --write-locks` dry-run analysis. If locks exist, verify they are committed and current (`cap diff` shows no dangling lockfiles); if not, create them via `--write-locks` and confirm the diff.
5. For cache misses, group by cause from the profile output: non-persistent task inputs, absolute paths in inputs, missing `@CacheableTask`, or `buildDir` leaks. Fix the cheapest wins first (input/path hygiene before task-annotation rewrites), one task at a time, re-building to confirm the miss converts to a hit.
6. After each change, run the focused task (`./gradlew :<module>:<task>`), then the full build; never claim a cache improvement from a single run with `--rerun-tasks` hidden in the log.
7. Run `cap verify` (with the Gradle build wired) and `cap diff` to confirm only build-script/properties/lockfile changes.
8. Record the audit facts (`cap memory add`): baseline vs. final hit ratio, locks status, and any build hygiene rules to keep.

## Verification
- [ ] Baseline and post-change hit ratios were both measured with the same task set; the improvement (if any) is restricted to documented task fixes.
- [ ] All dynamic version ranges are pinned or locked; `--write-locks` output committed and verified by `cap diff`.
- [ ] Lockfiles resolve offline-integration cleanly (`./gradlew resolveConfigurations` or equivalent passes).
- [ ] `cap verify` green; full clean-build (`./gradlew clean build`) passes once to prove cache independence.
- [ ] `cap diff` contains only gradle build-script, properties, and lockfile changes.

## Failure Handling
- Cache disabled and enabling requires permission: report the recommendation with measured numbers; do not silently flip `org.gradle.caching` without approval since it changes CI semantics.
- Locking a multi-project build breaks resolution: revert the lock diff with `cap rollback --task <id>`, lock module-by-module, and re-verify.
- A cache-miss fix changes task outputs: stop and compare outputs before/after; a "hit" that changes semantics is worse than a miss.
- Gradle not runnable here: report the blocker with the exact wrapper command; perform the config/CVE-adjacent audit only, stated as limited.

## Output Format
Final report:
- Baseline vs. post-fix cache hit ratio per task group; the task fixes applied and their measured effect.
- Lock state before/after: dynamic versions found, pins added, lockfiles committed.
- Any full-clean-build verification result and the final `cap diff` summary.
- Blockers or scope reductions with reasons.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap diff`, `cap verify`, `cap rollback`, `cap memory add`.