---
name: ui-microinteractions
description: Design motion and microinteractions — timing, easing, states, reduced-motion respect. Use when adding animations or transitions to a UI.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# UI Microinteractions

## Principles
- Motion communicates state, never decorates. Every animation answers: what changed, why, where attention goes.
- Durations: 150ms hover/focus, 250ms small transitions, 350ms larger (modals), max 500ms anything.
- Easing: `cubic-bezier` in-out for property changes; ease-out for entrances (fast start); ease-in-out for looped/continuous. Avoid default `ease` everywhere.
- Distances: translate ≤ 24px for micro; modals ≤ 48px.
- Stagger lists/cards 30-50ms, max 6 items — beyond that it feels slow.
- `transform`/`opacity` only (GPU-composited); animating width/height/top causes layout thrash.

## Patterns
- Hover/focus: color + transform + shadow change on same token; focus states always visible.
- Modal: fade + scale(0.98→1), backdrop fade; closing faster than opening (150ms vs 350ms).
- Page transitions: content fade-in-up 20px, 250ms; no full-page blur.
- Loading: skeleton shimmer (opacity pulse, not width jump), spinner only when unknown duration.
- Empty states: friendly illustration + one CTA, animate on appearance only.

## Reduced motion
- `@media (prefers-reduced-motion: reduce)`: durations → 0-1ms, disable scale/parallax/shimmer; keep opacity fades for state cues.
- Parallax and auto-scroll: disable entirely.

## Checklist
- [ ] Every animation below 500ms
- [ ] Only transform/opacity animated
- [ ] Reduced-motion variant exists
- [ ] Microinteractions map to real state changes (no pure decoration)