---
name: react-components
description: Build correct React components — hooks rules, state, effects, memoization strategy, error boundaries, patterns.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# React Components

## Hooks rules
- Top-level only, no conditionals; deps arrays complete (`exhaustive-deps`). Stale closures: capture into refs or use functional updates.
- `useState` for UI state; `useReducer` when transitions get complex; `useRef` for mutable values+capture; `useCallback`/`useMemo` only when prop-identity or heavy calc matters (profile first).
- Effects: browser work (subscribe, measure, timers) — always cleanup. Data fetching: better in a framework (React Router loaders / TanStack Query); if manual, AbortController + cancellation check.
- Don't mirror props into state (key or `useState(prop)` carefully); don't lie about deps to silence lint.

## Patterns
- Composition over props-drilling; `children` slots; render props vs context: context for cross-tree constants (theme, locale, auth).
- Error boundaries (class components still required) at app + route level; `<Suspense>` fallbacks per screen section.
- Keys: stable unique ids from data, never index (list reorder) unless static.
- Controlled components (value+onChange) for inputs; `defaultValue` for uncontrolled.
- Derived state: compute during render (`const shown = items.filter(...)`) — no effect to sync props.
- Split: container/presentation only when genuinely reused; don't over-split files.

## Anti-patterns
- Effects chains (fetch → set → other effect); giant useEffect with many deps; setState in render; mutating refs during render.

## Checklist
- [ ] Hooks at top level, deps complete
- [ ] Effects have cleanup
- [ ] Keys stable
- [ ] No effect doing derived-state's job
- [ ] Error boundary wraps any async/throw-heavy subtree
- [ ] Re-render hotspots profiled, memoized where measured