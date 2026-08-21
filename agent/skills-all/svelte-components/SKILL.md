---
name: svelte-components
description: Build Svelte 5 components — runes, stores, props, reactivity, transitions. Use for Svelte or SvelteKit component work.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Svelte 5 Components

## Runes (Svelte 5)
- `$state(...)` for reactive state (replaces `let` + text reactivity), `$derived(...)` for computed, `$props()` for props, `$bindable` for v-model-style two-way, `$effect` for reactions (auto-tracked — no manual deps).
- `$effect` runs after DOM update; cleanup a function return. Avoid `$effect` for derived values — `$derived` is declarative; effects for side effects only.
- Legacy mode (`let`/`export let`) still works — migrate when touching files.

## Props & events
- `$props()` typed; `$bindable()` for parent-controlled values; `onclick` handlers native (Svelte 5 removed event DOM directives `on:click` → `onclick`).
- Multiple root elements allowed; `{@const}`, `{#if}`, `{#each keyed}`, `{#await}` blocks.
- Slots: default, named, snippet props `{@render children()}` in Svelte 5 (snippets replace slot props).

## Stores (shared state)
- `writable`/`readable`/`derived` + `$store` auto-subscription still works; `store.subscribe` cleanup; `context` for component tree sharing (`setContext`/`getContext`).

## Transitions
- `transition:fade|fly|slide`, `in:`/`out:`, `animate:flip` — respect `prefers-reduced-motion`.
- Motion inside `{#key}` for state-driven re-animation.

## Perf
- Reactive blocks compile-time; keep `$effect` count low; SSR + hydration via SvelteKit; `export const prerender = true` for static pages.

## Checklist
- [ ] Runes in new code
- [ ] `$derived` not `$effect` for pure computation
- [ ] Effects cleanup
- [ ] Typed props
- [ ] No leaked subscriptions