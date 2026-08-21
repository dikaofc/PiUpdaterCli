---
name: typography
description: Choose and apply type systems — families, scale, hierarchy, readability, webfonts. Use when setting up or fixing typography.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Typography

## System
- Max 2 families: 1 UI/body + optional 1 display or mono. Mixing more looks amateur.
- Body base 16px, line-height 1.5–1.6. Headings: 20/24/30/36/48 scale, tighter line-height (1.1–1.25).
- Hierarchy: weight + size + spacing, not just size. Max 4 text styles.
- Measure (line length): 45–75 chars; max-width ~65ch for prose.

## Pairing
- Display + body contrast: serif/sans, or weight contrast within one family.
- Mono for code, numbers in tables, timestamps (`font-variant-numeric: tabular-nums`).

## Webfonts
- `font-display: swap`; preload critical woff2; subset; limit to 2-3 weights.
- Self-host or use system stack first: `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`.
- Set `font-optical-sizing: auto` for variable fonts.

## Checklist
- [ ] ≥ 4.5:1 contrast for body text
- [ ] No letter-spacing on lowercase body (legibility)
- [ ] `text-wrap: balance` on headings, `pretty` on paragraphs
- [ ] Line length capped
- [ ] Fallbacks defined for every custom family