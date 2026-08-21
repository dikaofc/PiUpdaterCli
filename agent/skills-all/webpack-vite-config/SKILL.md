---
name: webpack-vite-config
description: Configure Vite or Webpack correctly — dev server, production build, code splitting, assets, env, caching.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Build Tooling (Vite/Webpack)

## Vite (default for new apps)
- `vite.config.ts`: `server.proxy` for API (avoid CORS in dev), `build.target` ('es2020+' — mobile WebView compat), `build.outDir`, `base` for sub-path deploys.
- Aliasing `@` → src; plugins minimal (react/vue/svelte, typescript, eslint, path aliases).
- Env: `import.meta.env.VITE_*` only, typed via `vite-env.d.ts` + `ImportMetaEnv` interface; no secrets in VITE_ (client-exposed).
- Optimize deps: `optimizeDeps.include` for CJS-only or slow libs; pre-bundling speed-ups.
- Build checks: `vite build` + `vite preview` (production server) — preview honors base/proxy.

## Webpack (legacy/maintenance)
- Mode: development vs production script; `output.publicPath` for CDN; `optimization.splitChunks` for vendor split; `assetModules` (new Asset Modules replace file-loader).
- Loaders minimal: babel with `@babel/preset-env` targets; css-loader + mini-css-extract.
- Don't add unused loaders; keep config legible even if long.

## Shared
- Code splitting: route-level async imports (dynamic `import()`), vendor chunk pinned (stable hash for cache), runtime chunk.
- Hashing: `[contenthash]` on JS/CSS for long-term caching; `Cache-Control: immutable` those; HTML no-cache.
- Tree-shaking signals: ESM only, `sideEffects: false` in packages, avoid barrel files with churn.
- Source maps: production hidden or `nosources` — never expose full source.
- CI: cache node_modules + build cache; output size reports (budget failure = job fail).

## Checklist
- [ ] Production build passes with warnings at zero
- [ ] Route chunks split (no single mega-bundle)
- [ ] Contenthash caching effective
- [ ] No env secrets committed
- [ ] `vite preview`/local prod test done