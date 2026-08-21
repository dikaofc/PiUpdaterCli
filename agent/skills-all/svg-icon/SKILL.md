---
name: svg-icon
description: Create and optimize SVG icons — paths, viewBox, stroke vs fill, accessibility, sprite sheets.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SVG Icons

## Authoring
- viewBox `0 0 24 24` convention; icons scale to any size.
- Choose style: filled (bold, small sizes) vs stroked (`stroke-width: 1.5-2`, rounded caps) — stay consistent within a set.
- Hand-write common shapes from primitives (circle, rect, path with arcs) before reaching for icon libraries.
- Center strokes on integer/half grid to avoid blur: odd widths → `.5` offsets.

## Cleanliness
- Remove comments, empty groups, metadata (`<title>` kept or moved to a sibling).
- Merge paths when possible; convert styles to attributes (`fill="currentColor"`).
- Compact path data: relative commands when shorter, remove decimal noise.
- Minify: `npx svgo -i icon.svg` style (or keep readable if hand-maintained).

## Accessibility
- Decorative: `aria-hidden="true"` + `focusable="false"`.
- Informative (icon-only button): either `aria-label` on the button or `<title>` inside the SVG + `role="img"`.
- Color: inherit via `currentColor` so themes work everywhere.

## Sprite sheet
- Single `<svg style="display:none">` with `<symbol id="icon-x">`; reference `<use href="#icon-x">`.
- Build from individual files with a script; unique IDs; cacheable as one file.

## Checklist
- [ ] 24x24 viewBox, no fixed width/height
- [ ] currentColor fill/stroke
- [ ] aria-hidden or title present
- [ ] No nested redundant groups
- [ ] Same stroke/fill convention across the set