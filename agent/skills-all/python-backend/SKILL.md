---
name: python-backend
description: Build Python backends — FastAPI structure, pydantic, async, dependency injection, background tasks, packaging.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Python Backend (FastAPI)

## Structure
```
app/
  main.py          # app factory + lifespan
  api/routes.py    # routers (+deps)
  models/          # pydantic schemas
  domain/          # business logic
  db/              # repos/session
  core/            # config, security, logging
tests/
```
- FastAPI default; Flask/Starlette retrofit only for legacy.
- Pydantic v2: `BaseModel` schemas for request/response separated; `model_config = ConfigDict(from_attributes=True)` for ORM output; `Field(..., examples=...)`.

## Async correctness
- Async def routes; don't block with sync libs (use `anyio.to_thread` or async drivers); SQLAlchemy `AsyncSession`.
- Depends: `Depends()` for DB session (yield), auth user, pagination params — composition over decorator spaghetti.
- Background tasks: `BackgroundTasks` for fire-and-forget (email); real queues (Celery/ARQ/RQ) for reliability-critical jobs.
- Lifespan: create engine/pools in `@asynccontextmanager lifespan`, close on shutdown; on startup do migrations check (not auto-migrate on prod).
- Settings: pydantic-settings `Settings(BaseSettings)` with `.env`; `lru_cache` the getter; typed everywhere.

## Common mistakes
- Sync DB calls on async loop (thread exhaustion); redefining pydantic schemas for every endpoint (one per resource + thin variants); SQL strings interpolated; broad `except Exception` hiding bugs; no `__init__.py` structure → import order pain.

## Checklist
- [ ] pydantic request/response models, validation at boundary
- [ ] Async everywhere (or deliberately sync with threads)
- [ ] Settings typed + env-validated
- [ ] Graceful shutdown closes pools
- [ ] Alembic migrations under version control
- [ ] No blocking I/O in async functions