---
name: bundle-optimization
description: Shrink JS/CSS bundles — tree-shaking, code-splitting, and dedup.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: performance
  tags: [bundle, build, performance]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Bundle Optimization

## Objective
Reduce shipped bytes and parse time without breaking the build.

## Preconditions
- `cap repo` run; bundler config reviewed (`cap explore <webpack|vite|rollup|esbuild>`).

## Workflow
1. Run `cap repo` and build; inspect the bundle size report/treemap.
2. Enable/verify tree-shaking (ESM, sideEffects flag) and drop unused deps.
3. Code-split routes/heavy features into lazy chunks; share a vendor chunk.
4. Dedupe duplicated packages; align versions across the graph.
5. Compress (gzip/brotli) and set long-cache with content hashes.
6. Record size budget with `cap memory add` and enforce in CI.

## Verification
- [ ] Tree-shaking effective (no dead code).
- [ ] Routes code-split.
- [ ] No duplicate packages.
- [ ] Size budget enforced in CI.

## Failure Handling
- If a dep resists shaking, import named members or swap it.
- If split hurts, balance chunk count.

## Output Format
Bundle report: treemap findings, splits, dedup, and the CI size gate.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
