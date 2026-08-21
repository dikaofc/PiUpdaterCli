---
name: ui-components
description: Build reusable UI components — buttons, cards, modals, toasts, dropdowns — with state management, a11y, and theme integration.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# UI Components

## Component contract
- Props = state in, markup out. No side effects in render.
- Every component owns: 1 primary state, empty/loading/error variants, theme tokens (never raw hex).
- Naming: `Button`, `ButtonLink`, `ButtonIcon` — behaviors differ, share styles.

## Buttons
- Variants: primary / secondary / ghost / danger / link. Sizes: sm (32px) / md (40px) / lg (48px).
- States: hover, active (scale .97), focus-visible ring, disabled (opacity .5 + no pointer), loading (spinner swaps label, keeps width to prevent layout shift).
- Icon-only: `aria-label`, 44px hit area.

## Cards
- Border + shadow tokens (elevation 1-3), radius token, consistent padding scale.
- Interactive cards: full-card link zone (`::after` stretch), hover elevation change ≤ 200ms.

## Modal/Dialog
- `role="dialog" aria-modal="true"`, labelled by title; focus trap; Esc closes; backdrop click closes (with confirm if dirty); focus restore; body scroll lock.
- Width ≤ 640px, centered; mobile = bottom sheet or full-screen.

## Dropdown/Menu
- `aria-haspopup` + `aria-expanded`; close on outside click + Esc; keyboard: arrows navigate, Enter selects, Home/End; open direction aware of viewport edge.
- Item roles `menuitem` (or `option` in combobox).

## Toast/Notification
- `role="status"` for success/info, `role="alert"` for errors; auto-dismiss 4-6s except errors; pause on hover; stack with offset; no toast on load.

## Checklist
- [ ] Every interactive element has accessible name + keyboard path
- [ ] No layout shift on state change (fixed sizes)
- [ ] Tokens, not hardcoded values
- [ ] Loading/empty/error variants exist where data flows in