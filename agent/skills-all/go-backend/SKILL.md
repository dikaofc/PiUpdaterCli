---
name: go-backend
description: Build Go backends — project layout, net/http or chi, context, errors, concurrency, JSON handling.
category: Backend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Go Backend

## Layout (pragmatic)
```
cmd/server/main.go      # wiring only
internal/
  api/                  # handlers, middleware, routes
  domain/               # core types + logic
  store/                # DB/data access
  config/               # env config
```
- `internal/` for private; export `api` for consumers/gateway if needed. Standard lib first: `net/http` + ExtendableRouter (`chi`) beats Gin for new code — less magic, same ergonomics.

## Concurrency & context
- `context.Context` first param on every handler/service call: `r.Context()` → DB calls → cancellation/timeouts propagate. `http.Server{ReadTimeout, WriteTimeout, IdleTimeout}` set.
- Concurrency: `sync.Mutex`/`RWMutex` or `atomic` for shared state; never share `map` across goroutines without lock; `sync.WaitGroup` for fan-out; `errgroup` for parallel ops with error propagation.
- `go` statements: every goroutine must have a way to stop (context cancel, close channel) and error handling (buffered chan or errgroup) — no fire-and-forget leaks.

## Errors
- `fmt.Errorf("wrap: %w", err)` everywhere; errors.Is/As for sentinel/wrapped types (`ErrNotFound`).
- Handler boundary: map domain errors → HTTP status once, in api layer — domain stays transport-free.
- Custom error type with status + stable code for API consumers.

## JSON
- `encoding/json` structs with explicit tags `json:"id"`; `omitempty` aware (false/0 omitted = bug source for bool/int) — use pointers or `json.Encoder` when needed.
- Never `struct` without tag for API responses; `DisallowUnknownFields` on decode; cap body size (`http.MaxBytesReader`).

## Config
- Env-first config with typed struct + `os.Getenv` at boot; no global config pkg modifiable at runtime.

## Checklist
- [ ] Context through every call; server timeouts set
- [ ] Errors wrapped; HTTP mapping at boundary
- [ ] No leaked goroutines
- [ ] JSON tagged, decode bounded
- [ ] `go vet` + tests pass