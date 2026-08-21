---
name: css-cleanup
description: Refactor messy, duplicated, or over-specific CSS. Use when styles have grown unmaintainable, inline styles leak, or specificity wars break the UI.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CSS Cleanup

## When to use
Styles getting hard to change, `!important` fights, long selector chains, duplicated rules.

## Workflow
1. Inventory: list all rules, find duplicates by normalized value (colors, spacing, fonts).
2. Define tokens from the top ~10 repeated values (`design-tokens` skill).
3. Flatten specificity: target max depth 2, prefer class + utility patterns.
4. Remove dead rules (grep for each selector/class before deleting).
5. Inline styles → move to classes after confirming the component is the only user.
6. Extract repeated patterns into utility classes (`.stack`, `.visually-hidden`, `.card`).
7. Verify: screenshot/compare before vs after on key views.

## Rules
- Never delete a selector until you've confirmed zero references.
- One component's style never bleeds into others: scope with class names, not element selectors.
- Keep `!important` count at ~0; if needed, comment why.
- Delete unused CSS vars as you go.

## Checklist
- [ ] No duplicate rules remain
- [ ] No unused selectors remain
- [ ] Selector depth ≤ 3
- [ ] All colors/spacing come from tokens