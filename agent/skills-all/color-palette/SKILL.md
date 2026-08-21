---
name: color-palette
description: Build accessible color palettes — hues, scales, contrast-safe pairs, dark mode values. Use when choosing colors for a brand, chart, or UI.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Color Palette

## Method
1. Anchor hues: 1-2 brand hues, 1 neutral hue, 1 semantic set (danger/success/warning/info).
2. Scale: 50–950 (11 steps Tailwind-style), 50 near-white, 900-950 near-black. Derive by lightness, not pure black/white mixing.
3. Neutral first: gray scale qualifies the entire UI. Pick one hue + saturation (slightly warm or cool).
4. Semantic colors: 500 base, 100 bg, 700 text for each.

## Accessibility
- Text/dark-bg pairs: 700-on-50 or 900-on-100 etc. Verify ≥ 4.5:1.
- Accent (500) on white: check; often needs 600/700 for AA text.
- Don't rely on hue alone: add pattern, icon, or label for color-blind users.

## Dark mode
- Same hue, lower lightness; avoid pure black (`#000`) — use 900-ish neutral.
- Elevation in dark: lighter surface = higher elevation (unlike light mode).

## Deliverable
CSS vars (`--p-50`…`--p-950` per hue), plus a table listing every token with hex, usage, and contrast ratio against its primary background.