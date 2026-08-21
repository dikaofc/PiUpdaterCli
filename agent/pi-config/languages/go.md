# Language Guide: Go

Security and correctness analysis notes for Go services and tooling.

## Dangerous APIs

- `os/exec` with `sh -c` strings or shell metacharacters — command injection
  (`command-injection.md`); prefer `exec.Command` with argv.
- `text/template` vs `html/template` — mixing them allows XSS/SSTI
  (`template-injection.md`, `xss-analysis.md`).
- `unsafe`/`reflect` misuse; `cgo` boundaries (buffer handling)
  (`memory`/`c.md` concerns).
- `net/http` handlers with user paths into `http.ServeFile`/`http.FileServer`
  — traversal (`path-traversal.md`); use `http.ServeContent` with sanitized
  paths.
- `os.Open`/`os.Create` with user paths; symlink following
  (`filesystem-permissions.md`).
- `math/rand` for tokens — use `crypto/rand` (`randomness-analysis.md`).
- `yaml.Unmarshal`/`json.Unmarshal` into structs with `interface{}` fields —
  type confusion (`type-confusion.md`).

## Common Mistakes

- **Nil interface/dereference panics** in error paths (`exception-analysis.md`).
- **Ignored errors** (`_ =`), especially from `rows.Close`, `io.Copy`,
  `http.Client.Do` — resource leaks and silent failures (`connection-leak.md`,
  `file-descriptor-leak.md`).
- **Slices/maps shared by reference** between requests — data races and
  cross-request mutation (`concurrent-state.md`, `race-condition.md`).
- **Goroutine leaks** (unbounded `go func()`), unbounded channels — resource
  exhaustion (`resource-exhaustion.md`).
- **Integer overflow** in arithmetic (int32/int64) — boundary issues
  (`boundary-validation.md`); `len()` returns int, beware huge inputs.
- **Context misuse:** context canceled ignored; operations continue after
  client disconnect (`timeout-analysis.md`).
- **String normalization** — Go strings are bytes; unicode handling via
  `unicode`/`golang.org/x/text` (`unicode-handling.md`).

## Input Handling

- Validate at boundaries with explicit checks or schema libs; `encoding/json`
  with `DisallowUnknownFields` where appropriate (`schema-validation.md`).
- Watch `struct` tags not enforced at runtime.

## Filesystem / Networking / DB

- Path cleaning: `filepath.Clean` is not containment; verify `filepath.Abs` +
  prefix + `EvalSymlinks` (`path-traversal.md`).
- SSRF via `http.Client`/`net.Dial` to user-controlled URLs; validate scheme,
  host, and IP ranges (block link-local/metadata) (`ssrf-analysis.md`).
- DB: `database/sql` placeholders (`?`/`$1`); GORM/Orm raw strings
  (`query-safety.md`, `orm-security.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- `encoding/gob` and `json` of untrusted data: size limits, depth
  (`serialization-security.md`).
- `sync` primitives: mutex copies, lock ordering → deadlocks
  (`deadlock-analysis.md`); atomic ops for counters (`atomicity-analysis.md`).
- Auth: JWT (`golang-jwt` algorithm allow-list), OAuth libs
  (`jwt-analysis.md`, `oauth-analysis.md`).
- Errors: `fmt.Errorf` wrapping can leak internals to clients if returned
  verbatim (`sensitive-error-data.md`).
- Modules: `go.sum` integrity, `go vuln` (govulncheck), pinned versions
  (`dependencies/*`, `lockfile-analysis.md`).

## Testing

- `go test` + `testing/fuzz` (built-in fuzzing) (`fuzzing-strategy.md`);
  race detector (`-race`) for concurrency tests.

## Related

- `../skills/injection/*`, `../skills/concurrency/*`
- `../languages/c.md`, `../languages/cpp.md`
