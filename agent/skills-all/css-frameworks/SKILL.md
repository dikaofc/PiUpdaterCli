---
name: css-frameworks
description: Use CSS frameworks correctly — Tailwind/uno/Tailwind 4, daisyUI, bootstrap — tokens, purge, dark mode, customizing without fighting defaults.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CSS Frameworks

## Tailwind (v4)
- Config → CSS-first (`@theme`) in v4; tokens via `@theme { --color-brand-500: ... }`, dark mode via `@custom-variant dark (&:where(.dark, .dark *))`, variants for container queries.
- Use `@utility`/`@layer` for custom behavior; keep config minimal — default palette + a handful of brand tokens beats 200 custom hexes.
- Purging automatic (content detection); don't build dynamic class strings (`bg-${color}`) — use safelist or map objects.
- Dark mode: `dark:` variants fine; design tokens still preferred for multi-brand.

## Bootstrapping speed vs design freedom
- Tailwind: control + speed; pairs with daisyUI/flowbite for ready-to-use components.
- Bootstrap: works if already in stack; override via Sass variables + `$theme-colors`, never post-hoc overriding compiled CSS (war).
- Plain CSS is fine — framework is a tool decision, not a quality requirement.

## With frameworks
- Component markup: semantic HTML + framework classes smallest needed; prefer primitives over full components (overriding size).
- Tree-shaking: import only modules used; avoid CSS-in-JS runtime with SSR hydration-shots.
- Fonts/icons: subset; icon lib only icons actually used (or inline SVG).

## Checklist
- [ ] Token layer (brand/semantic) declared, no raw hex in markup
- [ ] No dynamic class name construction
- [ ] Dark variant works
- [ ] Purged/contents configured
- [ ] Framework default overrides via config, not re-CSS