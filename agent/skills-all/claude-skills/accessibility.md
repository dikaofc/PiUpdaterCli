---
name: accessibility
description: Make UIs accessible — semantics, keyboard, contrast, and ARIA done right.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [accessibility, a11y, frontend]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Web Accessibility (a11y)

## Objective
Meet WCAG basics so the interface works for keyboard and assistive-tech users.

## Preconditions
- `cap repo` run; component tree and current a11y issues reviewed (`cap explore <component|ui>`).

## Workflow
1. Run `cap search` for interactive elements missing labels/roles.
2. Use native semantic elements; add ARIA only to fill real gaps (not replace semantics).
3. Ensure every control is keyboard reachable with a visible focus ring.
4. Verify color contrast (4.5:1 text) and don't convey meaning by color alone.
5. Add alt text for images and labels for form controls; manage focus on route change.
6. Record a11y checks with `cap memory add` and wire an axe/lint check.

## Verification
- [ ] Semantic elements used; ARIA only where needed.
- [ ] Full keyboard path with focus visible.
- [ ] Contrast passes.
- [ ] Forms labeled; images alt present.

## Failure Handling
- If custom widget needed, follow the ARIA authoring pattern.
- If contrast impossible, adjust palette.

## Output Format
a11y report: semantic/keyboard/contrast fixes and the automated check added.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
