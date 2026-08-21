---
name: html-semantics
description: Write correct semantic HTML — landmarks, document outline, form structure, media, and the elements people misuse. Use for any HTML authoring or review.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# HTML Semantics

## Landmarks
- `header`, `nav`, `main` (one per page), `footer`; `aside` for complementary; `section` needs a heading (`aria-labelledby` or h1-h6); `article` for self-contained content.
- Skip link when `nav` is the first thing: `<a href="#main">Skip to content</a>`.

## Common mistakes
- `div` for buttons/links → use real elements; click handlers on `div` break keyboard users.
- `h1` per page (brand logo = img, not heading); heading order contiguous.
- `b`/`i` for styling → `strong`/`em` in content; use spans/CSS otherwise.
- `br` for spacing → margin/padding. `hr` = thematic break only.
- Nested interactive elements (button inside link) — invalid, restructure.
- Links: real `href` even when JS handled (graceful fallback), external links `rel="noopener"`.
- Images: `width`/`height` set even for CSS-controlled (CLS); `srcset`/`sizes` responsive.

## Forms & tables
- Form: `action` present; labels bound; `<button type="submit">` default inside form.
- Tables: `<caption>`, `<thead>`/`<tbody>`, `scope` on th; never layout tables.

## Text
- `<p>` for paragraphs; `<ul>`/`<ol>` for lists — `start`, `reversed` on ol; `<dl>` term/definition.
- `<time datetime="2026-08-20">` machine-readable dates; `abbr` with title on first use.
- Quotes: `<blockquote>` (cite attribute) + `<q>`.

## Checklist
- [ ] One main, one h1, skip link
- [ ] Interactive = native elements
- [ ] Images have alt + dimensions
- [ ] Forms fully labelled
- [ ] No presentational abuse (b/i/br/hr/div only when semantically right)