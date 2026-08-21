---
name: pwa-offline
description: Build Progressive Web Apps — manifest, service workers, offline strategy, caching, installability, updates.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# PWA / Offline

## Manifest
- `name`, `short_name`, `start_url`, `display: standalone`, `theme_color`/`background_color`, icons 192+512 (maskable + any). `id` stable.
- Link in `<head>`; installability needs manifest + HTTPS + service worker (Chrome 108+: manifest alone suffices for install prompt, but SW still needed offline).

## Service worker
- Register on `load` (not blocking); scope = `/`; control page after first load (clients.claim optional).
- **Stale-while-revalidate** (default for app shell + assets): serve cached, update cache, next load fresh. **Network-first** for entry HTML (catch offline fallback). **Cache-first** for hashed assets. **Network-only** for auth/sensitive.
- Precache: manifest list of hashed files (`workbox-precaching` or hand-rolled). Runtime cache with `Cache-Control` awareness — don't cache API responses with errors (status check before put).
- Cleanup: `cache.delete` old versions; version prefix on cache name; `skipWaiting` + `clientsClaim` on update → prompt "reload to update".

## Offline UX
- Offline fallback page + `navigator.onLine`/`online`/`offline` events — queue user writes (Background Sync or IndexedDB buffer) and sync on reconnect.
- Readiness: `caches.open`, IndexedDB for structured offline data (or a library); handle partial data (which parts available offline).

## Testing
- DevTools Application pane: manifest, SW, caches; "offline" checkbox; update cycles (`Update on reload`).
- Lighthouse PWA audits; test on fresh profile (no cache) + full offline + after version bump.

## Checklist
- [ ] Manifest complete, icons correct
- [ ] SW: precache + runtime strategy chosen per route type
- [ ] Errors never cached
- [ ] Offline fallback UX exists
- [ ] Update flow validates (old users get new version)
- [ ] HTTPS (or localhost) for SW