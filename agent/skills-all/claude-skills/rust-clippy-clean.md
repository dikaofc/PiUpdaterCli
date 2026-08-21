---
name: rust-clippy-clean
description: Clean clippy lints (including pedantic) with minimal, behavior-preserving fixes.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a Rust toolchain with `cargo clippy` available on the workspace.
metadata:
  category: coding
  tags: [rust, clippy, lints, pedantic]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Rust Clippy Clean

## Objective
Bring a Rust workspace to a clean `cargo clippy` run: zero warnings at the agreed lint level (default + selected `pedantic`/`nursery` groups), with every fix minimal and behavior-preserving. Lint policy changes (`#![warn]`/`#![allow]` attributes, `[lints]` table) are deliberate and counted, not ad-hoc suppressions.

## Preconditions
- `cap repo` detects a Cargo workspace; `cargo clippy` is installed and runnable.
- Baseline `cap test` is green and the lint-count baseline is recorded.
- The target lint level is agreed (default, `-D warnings`, or explicit `pedantic` subset).

## Workflow
1. Run `cap status` and `cap repo` to confirm workspace layout; read the lint configuration with `cap show Cargo.toml` (`[lints]` / `[workspace.lints]`) and existing `#![allow]` attributes.
2. Establish baseline counts: `cargo clippy --all-targets -- -D warnings` (or the agreed flag set) captured via `cap diff` and `cap memory add`.
3. Triage by category with `cap search "unwrap\(|expect\(|clone\(|iter\(\).*collect"` to size the largest fix families first.
4. Apply fixes family by family, smallest first: prefer `cargo clippy --fix` for mechanical lints, then hand-fix the rest. For each hand fix, read the site with `cap show <file> --lines a-b` and check the surrounding behavior (`cap explore <symbol>`) before changing.
5. For `pedantic` lints that are noise (e.g. `missing_errors_doc`, `module_name_repetitions`): add one workspace-scoped `#![allow]` with a `ponytail:` comment naming when to revisit — never per-line suppressions.
6. After each family, re-run `cargo clippy --all-targets` and `cap test`; a lint fix that breaks tests is a bug, not a lint win.
7. Finish with `cap lint` and `cap verify` (must include the clippy pipeline if wired), then `cap diff` to confirm fix-only changes.
8. Record the lint policy decisions and the resolved suppression list with `cap memory add`.

## Verification
- [ ] `cargo clippy --all-targets` emits zero warnings at the agreed level (exit code 0 with `-D warnings`).
- [ ] `cap test` full suite passes with baseline counts.
- [ ] Every `#![allow]` in the diff is workspace-scoped with a `ponytail:` comment; zero per-line suppressions added.
- [ ] `cap diff` shows only lint-driven edits — no refactors, no behavior deltas.
- [ ] `cap verify` green and the lint baseline is recorded in memory.

## Failure Handling
- A mechanical fix changes behavior (a test fails): revert that single fix with `cap rollback --task <id>`, re-read the site, and hand-fix with the behavior preserved.
- Pedantic noise is larger than the budget: narrow the scope to the agreed subset, keep the remaining lints on the `ponytail:` revisit list, and report the counts.
- Clippy not installed in this environment: report the blocker and the exact install command; do not silently skip the pipeline.
- Conflicting lints between workspace and crate: align in `[workspace.lints]`, re-run clippy, and record the resolution.

## Output Format
Final report:
- Baseline vs. final lint counts per severity/group; families fixed and how (mechanized vs. hand).
- Suppression list with `ponytail:` reasoning per entry; lint policy deltas in Cargo.toml.
- `cap test`/`cap verify` results and the final `cap diff` summary.
- Any blockers or scope reductions with reasons.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap explore`, `cap test`, `cap lint`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.