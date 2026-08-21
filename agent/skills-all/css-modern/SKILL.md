---
name: css-modern
description: Use modern CSS — grid, container queries, cascade layers, nesting, subgrid — without polyfills.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Modern CSS

## Adoption map (2026 baseline: all evergreen)
- **Grid**: 2D layout; `grid-template-areas` for page skeletons; subgrid (`grid-row: span 2 / span all`) for aligned card details.
- **Container queries**: `container-type: inline-size` + `@container` — component adapts to own width, not viewport. Replace most `@media` in card/grid components.
- **Cascade layers**: `@layer reset, tokens, base, components, utilities` — layers fix specificity wars at the architecture level. Unlayered styles beat layers; keep utilities last.
- **Nesting**: native `&` nesting — most Sass use-cases disappear; keep CSS files, drop preprocessors unless they add variables/mixins you actually use.
- **`:has()`**: parent selectors — `card:has(img:hover)`, form-group validation styling, layout state without JS.
- **Logical properties**: `margin-inline`, `padding-block`, `inset-inline` — RTL/LTR correct by default.
- **`color-mix()`, `light-dark()`, `oklch()`**: token math, theming without duplication.
- **`text-wrap: balance/pretty`**: heading/paragraph typographic polish, zero JS.

## Migration path
- Not "rewrite everything": add layers + logical properties + `:has` where payback is instant; CQ/subgrid when a component needs it.
- Audit `@media` usage → convert component-only breakpoints to containers.
- Remove vendor prefixes (autoprefixer debt); drop `-webkit-` except Safari-specific.

## Costs/risks
- Container query units can't style the container itself.
- `@layer` ordering mistakes = silent overrides — order declaration checked against a documented layer map.
- Old Android WebView (pre-2022) lacks `:has()`/CQ — know your support matrix, provide fallback class hooks.

## Checklist
- [ ] Layers declared and ordered
- [ ] Component responsiveness via containers
- [ ] No pixel-pushing media queries in components
- [ ] Logical properties for direction-sensitive values
- [ ] Preprocessor dep removed if possible