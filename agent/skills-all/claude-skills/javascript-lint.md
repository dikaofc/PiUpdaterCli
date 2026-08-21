---
name: javascript-lint
description: Set up consistent lint/format conventions for a JavaScript/TypeScript repo with eslint/prettier or native tools.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a JS/TS project; toolchain installs happen inside the repo only.
metadata:
  category: coding
  tags: [javascript, eslint, prettier, biomes, formatting]
---
<!-- ​​built by @dikaacode (telegram)​​ -->

# JavaScript Lint

## Objective
Establish one consistent lint-and-format convention for the whole repo: a lint config (ESLint flat config, or a native tool like Biome when the repo is Biome-native), a format config (Prettier or the tool's native formatter), editor/CI wiring, and a clean-enough baseline so `cap lint` is meaningful from day one. The chosen stack is decided by evidence already in the repo, not by preference.

## Preconditions
- The repo is JavaScript/TypeScript at its lintable surface (`cap repo` confirms; `source` is JS, TS, or mixed).
- No competing lint configs are active; or, if one exists, the migration to the single convention is in scope.
- Baseline `cap test` is green so linting is the only variable during setup.

## Workflow
1. Run `cap status` and `cap repo` to confirm ecosystem; read the nearest config candidates with `cap show` (`.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `biome.json`).
2. Inventory the tooling already present: `cap search "eslint|prettier|biome|standard|xo"` in package.json scripts and devDependencies; a tool already pinned wins over a new installation.
3. Decide the stack with `cap plan`: ESLint flat config + Prettier when the repo is ESLint-adjacent; Biome when its single-binary speed and native formatter fit the repo's size. Never install both formatters.
4. Write the config file(s) (`eslint.config.js`/`eslint.config.mjs`, `.prettierrc.json`, or `biome.json`), scoping rules to actual code: `recommended` presets, an agreed syntax baseline (ES modules, top-level await usage detected from `cap explore`), and the one style delta the repo already follows.
5. Add `scripts` (`lint`, `lint:fix`, `format`, `format:check`) and wire the format+lint check into the CI entry point; confirm `cap lint`/`cap format` now surface the new config.
6. Run the auto-fix pass (`eslint . --fix`/`prettier --write .`/`biome check --write`) and examine the `cap diff`: formatting-only churn is acceptable here, but flag any rule whose fix touched logic.
7. Hand-fix remaining lint errors with `cap show` on each site; run `cap lint` to zero errors (or a counted, commented suppressions list).
8. Run `cap test` to prove auto-formatting changed no behavior, then `cap verify` for the pipeline.
9. Record durable facts (`cap memory add`): the config files, the running scripts, and the style decisions so later sessions reuse them.

## Verification
- [ ] One lint + one format tool is authoritative; `cap search` shows no competing active config.
- [ ] `cap lint` and the format check both pass at zero errors/warnings on the whole repo.
- [ ] `cap test` counts unchanged after the format pass (auto-fix did not alter logic).
- [ ] CI wiring includes the lint/format check; `cap verify` green.
- [ ] Suppressions (if any) are counted and commented with a reason; zero blind `// eslint-disable-line` without context.

## Failure Handling
- Auto-fix changes apparent logic in the `cap diff`: revert that file with `cap rollback --task <id>` and rewrite the offending rule config or add a scoped disable with a comment.
- The existing repo style fights the default preset (e.g. semicolonless, 2-space vs 4-space): set the config to the repo's actual style instead of reformatting the whole codebase to a foreign default.
- A package that should be pushed to root config is scattered across per-folder configs: consolidate only when `cap diff` shows the folder configs are identical; otherwise keep the hierarchy and note it.
- No toolchain/network to install: write the config and scripts, run only `node --check`/`cap typecheck` as a partial verification, and state the lint limitation explicitly.

## Output Format
Final report:
- Chosen stack and the evidence that selected it (existing pins, repo conventions).
- Config files created/modified and the rules/style decisions (with deviations from presets).
- Scripts and CI wiring added; auto-fix churn stats (files/stats from `cap diff`).
- `cap lint`/format/`cap test`/`cap verify` results; suppressions list and reasons.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap show`, `cap search`, `cap explore`, `cap plan`, `cap lint`, `cap typecheck`, `cap test`, `cap verify`, `cap diff`, `cap rollback`, `cap memory add`.