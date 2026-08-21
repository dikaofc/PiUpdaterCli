---
name: error-handling-review
description: Audit error handling — swallowed errors, bare catch blocks, silent onError defaults, and missing structured logging.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [error-handling, exceptions, logging, robustness]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Error Handling Review

## Objective
Audit how a project or a given change handles failure: errors that are swallowed,
bare `catch` blocks, default callbacks that silently mask failures, and calls that
fail without any trace. Deliver per-site findings with severity and, for the worst
sites, a minimal patch that preserves the error at the right boundary.

## Preconditions
- Repository is indexed (`cap index --refresh`); the error-handling helpers are known
  or discoverable via `cap explore`.
- The project's logging conventions are identified (`cap rules check` warns when the
  logged code violates them).

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and project language.
2. Map the error vocabulary: `cap explore "error|exception|logger"` to find the project's error/shape helpers and logging utility.
3. Grep for handling sites: `cap search "catch *\("`, `cap search "onError"`, `cap search "catchAll|defaultError"`; in TypeScript also `cap search "catch (e|err) *\(\)"` for unused bindings.
4. Grep for silent paths: `cap search "catch *\(.*\) *\{\s*\}"` and scan for `console.log`-only "handling" (`cap search "console\.(log|error)"`).
5. Read each hit with `cap show <file> [--lines a-b]` and classify:
   - SWALLOW — error caught, nothing logged, nothing rethrown.
   - MASKED — `onError` default that returns a benign value and hides the failure.
   - BARE — `catch` with broad logic or an unused binding hiding intent.
   - UNTRACEABLE — failure path that emits no structured log at all.
6. Check contract expectations with `cap explore <public-fn>`; a public function that declares failure modes must not swallow (per project rules `cap rules check <file>`).
7. Run `cap risk --json` to scope the fix; patch only SWALLOW/BARE sites that are reachable and on user-facing paths.
8. Patch with the project's logger (`cap show <logger>` to copy its signature), rethrow or return typed errors; keep the diff minimal.
9. Verify: `cap verify`, `cap test`, `cap lint`, `cap typecheck`; roll back with `cap rollback --task <id>` on regression.
10. `cap memory add` the project error-handling convention (where errors must be logged/rethrown).

## Verification
- [ ] No SWALLOW or BARE site remains unpatched or unidentified on hot paths.
- [ ] Every patched site logs through the structured logger, not `console`.
- [ ] `cap verify` passes after patches.
- [ ] `cap risk --json` did not increase; `cap diff` shows only error-handling changes.
- [ ] Untraceable sites are listed in the report even if not patched.

## Failure Handling
- If a patch is not safe to apply (async boundary, no logger available in scope): report it, do not inline `console.log` as a stopgap — note the fix needed instead.
- If the logger API is unknown: `cap explore <logger>` first; inventing a new logging call counts as a finding, not a fix.
- If `cap verify` fails twice on the same site: `cap rollback --task <id>` and mark the site as DEFERRED with evidence.

## Output Format
- Findings table: file:line | class (SWALLOW/MASKED/BARE/UNTRACEABLE) | severity | impact | evidence.
- Patch list: files changed, what each change preserves (log, rethrow, typed error).
- Verification results (`cap verify`, `cap test`, `cap risk`).
- DEFERRED/UNVERIFIED sites and why.
- Convention recorded via `cap memory add`.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap risk`, `cap rollback`.
- CONTRACT.md §5 Rollback rules for failed patches.