---
name: typescript-migration
description: Migrate a JS codebase to TypeScript incrementally with strictness gained over time.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [typescript, migration]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# TypeScript Migration

## Objective
Add types without a big-bang rewrite, keeping the app runnable at every step.

## Preconditions
- `cap repo` run; build/test commands known.
- Current JS entry and config reviewed (`cap explore <tsconfig|babel|build>`).

## Workflow
1. Run `cap repo` and `cap show` the build to learn the JS toolchain.
2. Rename files to `.ts`/`.tsx` and enable `allowJs` so the project still builds.
3. Add `tsconfig` with `strict: false` first; flip flags on per-fixed module.
4. Type the public API and shared models first; infer the rest.
5. Run `cap typecheck` and `cap verify` after each module; fix before moving on.
6. Record the migration progress with `cap memory add`.

## Verification
- [ ] App builds/runs at every step.
- [ ] Strictness increases module by module.
- [ ] Public API typed.
- [ ] No `any` left in shared models (with justification).

## Failure Handling
- If a lib lacks types, add `@types` or a local declaration, not `any` everywhere.
- If build breaks broadly, shrink the strictness scope.

## Output Format
Migration plan: tsconfig flags, module order, and per-module typecheck status.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
