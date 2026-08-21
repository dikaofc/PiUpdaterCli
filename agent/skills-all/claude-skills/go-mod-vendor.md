---
name: go-mod-vendor
description: Audit the vendor directory, tidy go.mod, and upgrade Go dependencies with a per-module risk map.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a Go toolchain (go >= 1.17) on PATH with a module using `vendor/` or `go mod tidy` conventions.
metadata:
  category: coding
  tags: [go, golang, vendor, modules, dependencies]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Go Mod Vendor

## Objective
Bring a Go module's dependency state under control: vendor directory consistent with `go.mod`/`go.sum`, no unused or dangling entries, and any upgrades executed as a bounded, per-module sequence with a risk map that records why each upgrade happened and what verified it.

## Preconditions
- A `go.mod` exists and `cap repo` identifies the module root.
- Working tree is clean enough that a `cap diff` baseline is meaningful.
- Network access for `go mod download`/`go get` is available (or a module proxy is configured).

## Workflow
1. Run `cap status` and `cap repo` to confirm module layout; read `go.mod` with `cap show go.mod` and list vendored packages with `cap search` on `vendor/modules.txt`.
2. Establish the baseline: `cap diff`, then `go build ./...` and `go test ./...` results recorded via `cap memory add` as the green baseline.
3. Run `go mod verify` to check module integrity, then `go mod tidy` to reconcile go.mod with imports; re-run `go mod verify` after tidy.
4. If the repo uses vendoring, run `go mod vendor` and `go mod verify` inside vendor mode (`-mod=vendor`) so builds no longer depend on the network.
5. Audit for unused and outdated modules: `go list -m -u all` for upgrade candidates, and `go mod tidy` output for removals. Classify each candidate with `cap risk`: direct vs. indirect, major-version jumps, and modules on the critical import path.
6. Upgrade one module at a time (`go get <module>@<version>`, or `go get <module>@latest` only when the repo policy allows), re-running `go build ./...` + `cap test` after each; never batch unrelated upgrades in one step.
7. For major-version upgrades (e.g. v1 → v2), check import-path and API migration with `cap explore <symbol>` and `cap search "old-package-import"` before committing to the bump.
8. Run `go mod tidy && go mod verify` once more, then `cap verify` (which must include the Go build/test pipeline), and `cap diff` for the final change surface.
9. Record the dependency facts (versions, upgrade rationale, verified-by) with `cap memory add`.

## Verification
- [ ] `go mod verify` passes; `go mod tidy` produces no further diff (`go mod tidy` is idempotent).
- [ ] Vendor tree is complete: `go build -mod=vendor ./...` and `go test -mod=vendor ./...` pass offline.
- [ ] No unused modules remain (`go mod tidy` removed them; `cap search "vendor/<removed>"` shows no importers).
- [ ] Each upgrade is backed by a `cap risk` rationale; `cap diff` shows only go.mod/go.sum/vendor changes per step.
- [ ] `cap verify` green; baseline test counts preserved.

## Failure Handling
- `go mod tidy` removes a module that code still imports: stop, `cap rollback --task <id>` the go.mod, re-check the import path with `cap search`, and retry tidy.
- Upgrade breaks compilation: isolate with `cap explore` on the failing symbol, downgrade the single module with `cap rollback --task <id>`, and record the incompatibility.
- Vendor and module cache disagree (checksum mismatch): clear only the `vendor/` state via `go clean -modcache` with approval, re-vendor, and re-verify; never hand-edit `go.sum`.
- No network: report the blocker; skip upgrades but still deliver the tidy/vendor audit results, stating the network limitation explicitly.

## Output Format
Final report:
- Baseline vs. final go.mod: modules added/removed/bumped (old → new) with the `cap risk` rationale per entry.
- Vendor tree state: complete/incomplete, verify result, offline build confirmation.
- Removals from tidy with import-path evidence; any dangling `replace` directives found.
- `cap verify` results and the final `cap diff` summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap explore`, `cap diff`, `cap risk`, `cap test`, `cap verify`, `cap rollback`, `cap memory add`.