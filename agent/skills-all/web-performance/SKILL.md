---
name: web-performance
description: Optimize web performance — LCP, CLS, INP, asset budgets, caching. Use when a site is slow or before shipping.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Web Performance

## Core Web Vitals (targets)
- LCP ≤ 2.5s: hero/above-fold content. Fix: preload (or `fetchpriority=high`) LCP image, responsive `srcset`/`sizes`, `content-visibility: auto` below fold, server-side render meaningful content fast.
- INP ≤ 200ms: event handlers never block. Fix: keep main-thread work small, defer non-critical JS (`defer`/`type=module`), idle-time caches, no heavy O(n²) DOM ops on input.
- CLS ≤ 0.1: fixed dimensions on media (`aspect-ratio`), `font-display: swap` + size-adjust mapping, reserve space for ads/banners, avoid injecting layout above the fold.

## Asset budget
- Total JS ≤ 200KB gz on critical path; CSS ≤ 50KB; images dominate — lazy-load below fold, convert to WebP/AVIF, `loading="lazy"` + `decoding="async"`, width/height set.
- Third-party: audit — each costs. Load in `defer`, self-host analytics where possible.
- Fonts: subset + `font-display: swap` + preload 1-2 weights, `system` fallback first.
- Caching: immutable+long TTL hashed assets, revalidate HTML, `Cache-Control: no-store` on sensitive pages.

## Techniques
- Minify + gzip/brotli at server/CDN. HTTP/2+ multiplexing.
- Route splitting (lazy imports), tree-shake, avoid chained waterfalls.
- Preload/push only what feeds LCP; `preconnect` critical origins.
- Measure first: Lighthouse, WebPageTest, real-user data. Optimize what the numbers show, not guesses.

## Checklist
- [ ] LCP ≤ 2.5s on 3G-throttled test
- [ ] All media has dimensions
- [ ] No render-blocking third-party
- [ ] Budgets enforced (bundlesize check)
- [ ] Images in next-gen formats, lazy below fold