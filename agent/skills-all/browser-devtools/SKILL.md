---
name: browser-devtools
description: Debug frontend issues with browser DevTools — console, network, elements, performance, responsive, memory.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Browser DevTools

## Console
- `console.table()`, `debugger;` breakpoints, `copy()` objects. Filter levels; preserve log across navigation.
- Errors: trace source maps, reproduce minified → map back.

## Elements
- Computed tab → why a rule won: specificity, cascade, inheritance.
- Force state (hover/focus) for styling states; box model overlay.
- Edit code in place to test changes fast.

## Network
- Block/offline modes; throttling (3G Fast ~ 1.6Mbps); latency view.
- Waterfall: find choke (TTFB, download, queue). Filter by type; initiator column shows what loaded a script.
- Copy as cURL for API debugging.

## Performance (Chromium)
- Record → identify main-thread long tasks (> 50ms), layout thrash frames, forced reflow.
- Lighthouse tab: run with mobile throttle; act on Audits.

## Responsive
- Device toolbar: 360px + 1280px minimum; test text overflow, touch target overlap.
- `emulation` of `prefers-color-scheme` and `prefers-reduced-motion` for those paths.

## Memory
- Heap snapshots: find retained detached DOM, growing caches. Allocation timeline during a leak repro.
- Event listeners tab: duplicate listeners on re-mounts.

## Pro tips
- `$0` = last inspected node; `$x('//path')` XPath; `getEventListeners($0)`.
- CSS grid/flex overlay tool for alignment debugging.
- Coverage tab: find unused CSS/JS shipped to users.

## Checklist
- [ ] Reproduced with throttling 3G
- [ ] Long tasks located and reduced
- [ ] Leak confirmed via memory timeline
- [ ] Responsive at 360/768/1280
- [ ] No console errors on clean load