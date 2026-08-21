---
name: node-backend
description: Build Node.js backends — Express/Fastify/Hono structure, middleware, async errors, validation, environments.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Node.js Backend

## Framework choice
- Fastify or Hono (modern, TS-native, schema validation built-in) for new builds; Express only in existing stacks (add error-handling discipline manually).
- Structure by domain, not by file-type: `routes/`, `services/` (business logic), `repos/` (data access), `middleware/`, `validation/`.

## Core discipline
- **Async errors**: every async handler wrapped — Express 4 needs explicit wrapper or `express-async-errors`; Fastify/Hono catch by default. Never swallow errors with empty catch.
- **Validation at boundary** (`api-validation`): zod/typebox schemas on input; typed request handlers. Internal invariants unvalidated.
- **Middleware order**: security (CORS, helmet) → logging/request-id → auth → routes → 404 → central error handler (last, 4 args).
- **Env config**: `env.ts` parsing `process.env` through zod once at boot; fail fast on missing required keys. Never `process.env` reads scattered.
- **Secrets**: env/secret manager only — no config files with credentials committed.
- **Logging**: structured JSON (pino) with `request_id`; no console.log in lib code.
- **Process**: graceful shutdown (SIGTERM → close server, drain, flush); crash on uncaught (`uncaughtException` log + exit 1) — don't continue in undefined state.

## Performance notes
- JSON body limit set (`limit: '1mb'`), streaming uploads; `gzip` only where CPU trades win; cluster/`--max-old-space-size` understood; DB connections pooled.
- Heavy compute: worker threads/child process off the event loop.

## Common failures
- Blocking `fs.readFileSync`/`JSON.parse` on hot path; unbounded request bodies; missing timeouts (fetch/socket); SQL string building (`sql` rules).

## Checklist
- [ ] Central error handler, async-safe
- [ ] Input validated at entry
- [ ] Structured logs + request_id
- [ ] Graceful shutdown
- [ ] No blocking calls on hot path
- [ ] Env validated at boot