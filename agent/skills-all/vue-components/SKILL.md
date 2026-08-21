---
name: vue-components
description: Build correct Vue 3 components — composition API, refs, computed, watchers, slots, v-model, reactivity rules.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Vue 3 Components

## Composition API
- `<script setup>` default; props/emits declared (`defineProps`/`defineEmits`) — strict typing via `withDefaults`.
- `ref` (any type, `.value` in script), `reactive` (objects only; no destructuring — lose reactivity), `computed` for derived values; `readonly` to expose internals.
- `watch`/`watchEffect`: watch specific sources + `{ deep: true }` rarely; effects that depend on reactive reads belong in computed/watchEffect. Cleanup fn on watchers (timers/subscribers).
- Lifecycle: `onMounted` → DOM/API; `onUnmounted` → cleanup; don't fetch in setup body (runs during render).

## Reactivity rules
- Don't replace reactive objects you subscribed to (reassign loses links) — mutate or use `ref`.
- `v-for` + `v-if` same element = anti-pattern (v-if wins); wrap in `<template>`.
- Keyed list; template refs `ref="el"` arrays need function refs in loops.
- Prop mutation: never mutate props — emit events: `emit('update:modelValue', v)` for v-model.

## Reusables
- Composables (`useXyz`) for cross-component logic; naming `use*`.
- `defineModel()` (3.4+) for v-model composability; `defineExpose` for methods to parents.
- Slots: default + named + scoped slots `<template #item="{ item }">`; dynamic `<component :is>` for switching.

## Perf
- `shallowRef` for big objects; `v-memo` rare; `markRaw` for non-reactive third-party.
- `defineAsyncComponent` + `Suspense` code-splitting.

## Checklist
- [ ] No `v-if`/`v-for` same element
- [ ] Props not mutated; emits used
- [ ] Watchers cleaned up (onUnmounted/stop)
- [ ] No destructured reactive loss
- [ ] Typed props/emits