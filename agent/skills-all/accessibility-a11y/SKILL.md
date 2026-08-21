---
name: accessibility-a11y
description: Make web UIs accessible — semantic HTML, keyboard nav, ARIA, focus, screen readers, WCAG AA. Use when building or auditing any UI.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Accessibility (a11y)

## Core
- Semantic HTML first: `button`, `nav`, `main`, `section[aria-labelledby]`, `table`, `ul` — ARIA only when HTML can't do it.
- Keyboard: every interactive element reachable + operable with Tab/Enter/Space/arrows. Visible `:focus-visible` ring.
- Focus order matches visual order. Skip link for nav.
- Labels: every input needs `<label for>` (or aria-label when visual label impossible).
- Screen reader: `aria-live="polite"` for dynamic updates, `aria-expanded` for toggles, `role="dialog"` + focus trap + Escape for modals.
- Color: 4.5:1 text, 3:1 large text/UI components; never color-only signals.
- Motion: respect `prefers-reduced-motion` — replace animations with opacity transitions.
- Touch: targets ≥ 44px, hit area padded, no hover-only interactions.

## Audit checklist
- [ ] Tab through entire page: no traps, logical order, visible focus
- [ ] Forms: error messages linked (`aria-describedby`) and announced
- [ ] Images: meaningful `alt` or decorative `alt=""`
- [ ] Headings in order (h1→h2→h3), no skips
- [ ] Modal/drawer: focus in, focus out, focus restored, Escape closes
- [ ] Links distinguishable (underline or 3:1 contrast + non-color cue)
- [ ] Test with a screen reader (TalkBack / VoiceOver / NVDA)
- [ ] PDF/attachment equivalents when content is visual only