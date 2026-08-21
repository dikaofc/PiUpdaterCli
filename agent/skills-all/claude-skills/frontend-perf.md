---
name: frontend-perf
description: Optimize web render — critical path, images, fonts, and main-thread work.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: performance
  tags: [frontend, performance]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Frontend Performance

## Objective
Cut load and interaction latency with measured, prioritized front-end fixes.

## Preconditions
- `cap repo` run; bundler and asset pipeline reviewed (`cap explore <build|asset|component>`).

## Workflow
1. Run `cap repo` and measure (Lighthouse/WebPageTest) to find the real bottleneck.
2. Minimize critical-path CSS/JS; defer non-essential; inline above-the-fold.
3. Optimize images (format/size/srcset) and fonts (subset, display=swap).
4. Reduce main-thread jank: code-split, debounce, move work off the critical path.
5. Cache static assets with long TTL + content hashing.
6. Record metrics baseline/target with `cap memory add`.

## Verification
- [ ] Measured improvement on LCP/INP.
- [ ] Critical path minimized.
- [ ] Images/fonts optimized.
- [ ] Assets hash-cached.

## Failure Handling
- If metric regresses elsewhere, bisect the change.
- If third-party script dominates, defer or self-host.

## Output Format
Perf plan: measured bottlenecks, fixes applied, and before/after metrics.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
