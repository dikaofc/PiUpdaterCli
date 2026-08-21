---
name: node-modernize
description: Migrate a CommonJS Node codebase to modern ESM and top-level await while preserving behavior exactly.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: coding
  tags: [node, esm, cjs, migration, javascript]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Node Modernize

## Objective
Convert a CommonJS (CJS) Node.js package to modern ECMAScript Modules (ESM): `import`/`export` syntax, top-level await where safe, `node:` specifier prefixes, and directory imports replaced with explicit specifiers — with zero observable runtime behavior change. Each conversion is verified before the next one proceeds.

## Preconditions
- Working tree is clean or the migration scope is agreed; `cap status` shows no unrelated in-flight changes.
- The package's runtime target supports ESM (Node.js >= 18, or a bundler that compiles ESM) — confirm via `cap repo` and the engines field.
- The set of entry points (package.json `main`/`exports`/`bin`) and their importers is known.

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and package layout; record the current `cap diff` as the pre-migration baseline.
2. Inventory CJS usage with `cap search "require\(|module.exports|exports\." ` and `cap search "__dirname|__filename"` to size the migration.
3. Read package.json with `cap show package.json`; add `"type": "module"` (or rename to `.mjs`) and record a `cap plan` noting engines, `exports` map, and the migration order (leaves to root).
4. Convert leaf modules first: `require` → `import`, `module.exports` → `export default`/named `export`, and `require("node:...")` paths to explicit `node:` specifiers. Verify each with `cap explore <symbol>` so no exported name is lost.
5. Replace `__dirname`/`__filename` with `import.meta.dirname` (Node >= 20.11) or `path.dirname(fileURLToPath(import.meta.url))`, and relative `require("./x")` with explicit `./x.js` extensions.
6. Promote `await` at module top level only where the call has no ordering dependency with other module side effects; check with `cap search "process.on|require.*\.\(|\.then"` to avoid breaking init-order assumptions.
7. After each batch, run `cap test` (targeted to affected files), then `cap lint` and `cap typecheck`; stop and fix before continuing.
8. Run `cap verify` for the full pipeline, then `cap diff` to confirm only intended conversions.
9. Run `cap risk` and `cap rollback --task <id>` if any step breaks the build; record discovered specifier/edge-case facts with `cap memory add`.

## Verification
- [ ] All `require(` and `module.exports` removed (grep via `cap search` shows zero hits, or only documented exemptions).
- [ ] `cap test` full suite passes with the same pass/fail counts as the baseline.
- [ ] `cap lint` and `cap typecheck` pass; `cap verify` green.
- [ ] `cap diff` shows only conversion changes — no behavior/refactor deltas.
- [ ] Entry points still resolve (`cap repo` exports map loads); `node --check` on each converted file.

## Failure Handling
- On any failing test: `cap rollback --task <id>` to the last green batch, re-run `cap show` on the offending module, and convert it in smaller steps. Never mix a behavior fix into a conversion commit.
- If a dependency is CJS-only and `import` interop is inconsistent: keep the `require` via `createRequire(import.meta.url)` in a single adapter module with a `ponytail:` comment naming the replacement when the dep ships ESM.
- If `engines` contradicts ESM support: stop and report the conflict; do not convert entry points consumed by older runtimes.

## Output Format
Final report:
- Migration order applied (leaf → root) and files converted (count, and the biggest `cap diff` deltas).
- Behavioral equivalences verified per module; any interop shims introduced and why.
- Baseline vs. final test counts; `cap lint`/`cap typecheck`/`cap verify` results.
- Residual CJS (exemptions) with reasons; `cap risk` score of the final diff.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap plan`, `cap test`, `cap lint`, `cap typecheck`, `cap verify`, `cap diff`, `cap risk`, `cap rollback`, `cap memory add`.