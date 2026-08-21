---
name: state-management
description: Choose and implement frontend state management — server vs client state, stores, caching, invalidation.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# State Management

## Split first
- **Server state** (data from APIs): cache + invalidate + refetch — TanStack Query (React), SWR, or a framework loader. Never dump API data into a global store and hand-manage staleness.
- **Client state** (UI: modal open, filters, draft): local component state or a small store.

## Picking a store
- React: Zustand (tiny, hook-based) for most apps; Redux Toolkit only when teams demand architecture + devtools at scale; Context for theme/auth constants (not frequent updates — re-render cost).
- Vue: Pinia. Svelte 5: runes/`$state` + context; stores for shared modules.
- Signals vs stores: signals fine for fine-grained reactive; stores when you need history/devtools/middleware.

## Rules
- Single source of truth: computed/selectors stay pure — derive, don't duplicate.
- Immutable updates (or library-enforced); no random direct mutation.
- Async: loading/error/success states modeled explicitly (enums or discriminated union), not boolean soup.
- Persistence: explicit storage adapter (localStorage/sessionStorage/AsyncStorage) + hydration validation; never persist whole stores blindly (version it).
- Undo/redo: time-travel works only with immutable state snapshots.

## Caching (server state)
- Keys = query identity; staleTime > 0 to avoid refetch storms; invalidate on mutation (`onSuccess` refetch or optimistic update with rollback).
- Infinite scroll/pagination keys; dedupe concurrent requests.

## Checklist
- [ ] Server data not in global client store
- [ ] Async states modeled, errors surfaced
- [ ] Updates immutable
- [ ] Persistence validated + versioned
- [ ] Derived values computed, not stored-in-parallel