---
name: ssr
description: Add SSR/streaming for fast first paint and SEO without hydration bugs.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [ssr, frontend, performance]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Server-Side Rendering

## Objective
Render on the server for speed/SEO while keeping client interactivity correct.

## Preconditions
- `cap repo` run; framework and current rendering mode reviewed (`cap explore <render|app|server>`).

## Workflow
1. Run `cap explore` for the app entry and data-loading boundaries.
2. Move data fetching to the server; stream shell first, then content.
3. Ensure hydration matches server markup (no random IDs/time on render).
4. Guard browser-only APIs behind `typeof window`/effects to avoid SSR crashes.
5. Cache rendered output where safe; set correct status/headers.
6. Record the rendering model with `cap memory add`.

## Verification
- [ ] First paint from server (no blank flash).
- [ ] Hydration matches markup.
- [ ] No window-at-render crashes.
- [ ] Caching safe + headers correct.

## Failure Handling
- If hydration mismatch, stabilize markup.
- If SSR slow, stream + cache.

## Output Format
SSR design: data flow, streaming, hydration rules, and caching.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
