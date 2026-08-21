---
name: dark-mode
description: Implement dark mode properly — token architecture, light-dark(), persistence, no flash of wrong theme, OS sync.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dark Mode

## Architecture
- Theme = tokens, never component tweaks. Define both palettes once (`design-tokens`).
- Modern CSS: `color-scheme: light dark` + `light-dark(lightVal, darkVal)` per token — zero JS.
- Fallback (wider compat): `[data-theme="dark"]` overrides on `:root`.
- Components consume tokens only; switching theme = flipping one attribute.

## State machine
1. On page load, before paint: inline script reads `localStorage.theme` → stored, else `matchMedia('(prefers-color-scheme: dark)')` → dark, else light. Sets `data-theme` on `<html>`.
2. Toggle button sets attribute + localStorage. Radio for system/light/dark (3 states).
3. No FOUC: attribute set in `<head>` script, not after DOM ready.

## Details
- Off-white/off-black surfaces (#0f1115 range), not pure black.
- Images: `filter: brightness(.8)` on photos; keep screenshots/UI shots unmapped.
- Shadows → borders in dark (elevation via surface lightness, not shadows).
- `prefers-color-scheme` in media queries for embedded widgets.
- Test: switch at runtime — no dead zones (cards invisible), no hardcoded hex left (grep).

## Checklist
- [ ] No flash of light theme on reload
- [ ] OS sync works; manual choice persists
- [ ] Every color token has a dark value (grep for hex in components = fail)
- [ ] Form controls and scrollbars use `color-scheme`