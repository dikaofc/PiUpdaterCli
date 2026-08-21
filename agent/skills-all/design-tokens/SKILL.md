---
name: design-tokens
description: Create and apply design tokens — colors, typography, spacing, radius, shadows — as CSS custom properties or JSON for any frontend. Use when starting a new UI, theming, dark mode, or making styles consistent.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Design Tokens

## When to use
New UI, restyle, dark mode, multi-brand theming, or when styles have inconsistent values.

## Workflow
1. Define scales first, components second. Never hardcode values in components.
2. Color: base palette → semantic roles (bg, surface, text, border, accent, danger, success, warning) → state variants (hover, active, disabled).
3. Type: base 16px, scale 12/14/16/18/20/24/30/36/48; max 2 families (UI + mono).
4. Spacing: 4px grid — 4/8/12/16/24/32/48/64.
5. Radius: 4/8/12/full. Shadows: 2-3 elevation levels.
6. Contrast: text ≥ 4.5:1 (WCAG AA) on its background; verify accent colors too.

## Output format
CSS custom properties under `:root`, `light-dark()` pairings or `[data-theme]` blocks. Or JSON for cross-platform consumption.

## Checklist
- [ ] Semantic names, not descriptive (`--text-primary` not `--gray-900`)
- [ ] Dark values defined for every light token
- [ ] Focus ring token defined
- [ ] Motion durations on one scale (150/250/350ms)
- [ ] No magic numbers outside the scales above
