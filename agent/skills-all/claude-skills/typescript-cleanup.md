---
name: typescript-cleanup
description: Eliminate `any`, enable strict mode, and remove ts-ignore directives without changing runtime behavior.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a TypeScript project with `tsc` available via the project toolchain.
metadata:
  category: coding
  tags: [typescript, strict, types, cleanup]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# TypeScript Cleanup

## Objective
Move a TypeScript codebase toward full type safety: eliminate `any` (replacing with precise types or `unknown` + narrowing), remove `@ts-ignore`/`@ts-expect-error`/`@ts-nocheck` directives except where a defect in a library's types makes them unavoidable, and enable `strict` compiler flags — all without changing emitted runtime behavior. Each removal is bounded so the compile error budget never explodes.

## Preconditions
- `cap repo` confirms a TypeScript project and the tsconfig files involved.
- A baseline `cap test` run is green (or the failing set is documented as pre-existing).
- The strict-mode target (folder, package, or whole repo) is agreed and scoped.

## Workflow
1. Run `cap status` and `cap repo` to verify environment and locate tsconfig files; read them with `cap show tsconfig.json`.
2. Inventory looseness with `cap search "as any|<any>|: any\[|any\[\]|@ts-ignore|@ts-expect-error|@ts-nocheck"` and count per file via `cap tokens <file>` for triage order.
3. Record the baseline `cap diff` and run `cap plan` enumerating the removal order: highest-count, most-central `any` first.
4. For each `any`: read the usage with `cap show <file> --lines a-b`, infer the real type from producers (`cap explore <symbol>`), and replace with the concrete type or `unknown` plus a narrowing guard at the boundary. Do not invent a type: name the models or function signatures it flows from.
5. Remove `@ts-ignore`/`@ts-expect-error` one at a time; when the line becomes an error, fix the underlying type instead of restoring the directive. Reserve a counted `ponytail:` list for library-defect cases that must stay.
6. Enable `strict` flags incrementally (`strictNullChecks` first when starting from none), re-running `cap typecheck` after each flag; cap the fix loop at a budget of N errors per flag (default 50).
7. After each file batch, run `cap test --target <file>` and `cap typecheck`; fix regressions before continuing.
8. Run `cap verify` for the full pipeline and `cap diff` to confirm zero runtime-code deltas outside type positions.
9. Record durable type conventions (`cap memory add`) and finish with `cap risk` on the final diff.

## Verification
- [ ] `cap search` reports zero `any` and zero ts directives not on the documented exemption list.
- [ ] `strict: true` (or the agreed flag set) is on in the scoped tsconfig; `cap typecheck` passes.
- [ ] `cap test` baseline counts unchanged; `cap verify` green.
- [ ] `cap diff` touches only type annotations, type imports, and narrowing guards — no logic changes.
- [ ] Runtime output (build artifact diff) identical where the project builds.

## Failure Handling
- Error budget exceeded: roll back the current flag with `cap rollback --task <id>`, shrink scope to the folder, and re-run `cap risk`.
- A type is genuinely unknowable (data from untrusted JSON): use `unknown` + runtime validation at the trust boundary; document the boundary with a comment.
- Library types are wrong: report upstream with a minimal repro instead of widening; keep the counted exemption until upstream fixes.
- Runtime behavior seems altered: stop, `cap show` the changed lines, and revert the offending annotation; type positions must never change control flow.

## Output Format
Final report:
- Counts before/after: `any`, `@ts-ignore`, `@ts-expect-error`, `@ts-nocheck`; strict flags now on.
- Files with the most removals and the type patterns introduced (e.g. branded types, `unknown` guards).
- Exemption list with `ponytail:` reasoning per entry.
- `cap test`/`cap typecheck`/`cap lint`/`cap verify` results and final `cap risk` score.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap tokens`, `cap plan`, `cap explore`, `cap typecheck`, `cap test`, `cap verify`, `cap diff`, `cap risk`, `cap rollback`, `cap memory add`.