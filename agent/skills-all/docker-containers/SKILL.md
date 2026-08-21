---
name: docker-containers
description: Write good Dockerfiles — base images, layer caching, multi-stage, non-root, healthchecks, .dockerignore.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Docker Containers

## Base image & deps
- Distroless (`gcr.io/distroless`) or slim (debian-slim, alpine for tiny) — never `:latest` (pin digest or minor); understand upstream maintenance.
- Node image: prefer distroless; `npm ci --omit=dev` in build stage, copy `package-lock.json` first for layer cache.
- Python: `python:3.x-slim`, install with `--no-cache-dir`; Go: multi-stage build (golang → distroless) — absolute tiny.

## Dockerfile pattern (multi-stage)
```dockerfile
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build   # or prisma generate etc

FROM node:22-slim AS runtime
ENV NODE_ENV=production
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:3000/healthz || exit 1
CMD ["node", "dist/index.js"]
```

## Rules
- Order COPY by change-frequency (lockfiles → code) so cache hits survive; multi-stage to strip build tools.
- **Never run as root**: `USER` in final stage; chown needed files (non-root can't bind 80 → use 3000+).
- `.dockerignore`: node_modules, .git, dist-remnants, env files, caches — keeps context small + no secret leaks via layer.
- Healthcheck in image (platforms that don't read it still run it). `CMD` array-form (no `sh -c` unless needed); `WORKDIR` explicit.
- No `apt-get install` without `rm -rf /var/lib/apt/lists/*`; single RUN layer when it saves bytes.
- **Secrets never in image**: build args only for non-secret values; secrets via env/mount at runtime.

## Common footguns
- `npm ci` vs `npm install` (reproducibility); missing `--frozen-lockfile`; caching node_modules into image (waste); `latest` unpinned; big contexts slowing pulls.

## Checklist
- [ ] Pinned base, slim/distroless, multi-stage
- [ ] Lockfile-first COPY ordering
- [ ] Non-root USER
- [ ] .dockerignore excludes secrets+caches
- [ ] HEALTHCHECK + array CMD