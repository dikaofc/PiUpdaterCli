---
name: responsive-layout
description: Build mobile-first responsive layouts with CSS Grid, Flexbox, and container queries. Use for any layout work that must work across phone, tablet, and desktop.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Responsive Layout

## Principles
- Mobile-first: design at 360px, scale up. Media queries add, never remove.
- Fluid between breakpoints: clamp(), fr units, auto-fit/auto-fill; avoid fixed pixel widths.
- Breakpoints as needed, not preset devices: ~640, ~1024, ~1280.

## Techniques
- Grid: `grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr))` for card grids.
- Two-pane: `grid-template-columns: 1fr` → `minmax(0, 1fr) minmax(0, 3fr)` at md.
- Containers: `container-type: inline-size` + `@container` for component-level responsiveness.
- Overflow: `min-width: 0` on grid/flex children that shrink; `overflow-wrap: anywhere` on long text.
- Tables: `display: block; overflow-x: auto` wrapper, or restructure rows as cards at small sizes.
- Images: `width: 100%; height: auto` or `object-fit` with fixed height.

## Checklist
- [ ] Works at 360px with no horizontal scroll
- [ ] Touch targets ≥ 44x44px
- [ ] No layout shift on font/asset load (fixed dimensions or aspect-ratio)
- [ ] Tests with real text lengths (long words, URLs, user names)
