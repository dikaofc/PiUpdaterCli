# Language Guide: Rust

Security and correctness analysis notes for Rust services and tooling.

## Dangerous APIs

- `std::process::Command` with `.arg` is safe; **shell strings** (`sh -c`) via
  `Command::new("sh")` are injection (`command-injection.md`).
- `unsafe` blocks: raw pointer arithmetic, `static mut`, `MaybeUninit` misuse —
  memory safety (`memory` concerns; `c.md`/`cpp.md` analogies).
- `std::fs` with user paths; `Path::join` on user input — traversal
  (`path-traversal.md`); use `std::fs::canonicalize` + prefix check.
- `format!`/`write!` into SQL/HTML/shell strings — injection via string
  formatting (`sql-injection.md`, `xss-analysis.md`).
- `rand` crate for security tokens — use `rand::rngs` with `getrandom`/`OsRng`
  (`randomness-analysis.md`).
- `serde` with `#[serde(deny_unknown_fields)]` omitted — mass assignment
  (`mass-assignment.md`); `untagged`/`any` deserialization — type confusion
  (`type-confusion.md`).
- `Regex::new` with user patterns → ReDoS (`cpu-exhaustion.md`).

## Common Mistakes

- **Panics as control flow:** `unwrap()`, `expect()`, indexing, `panic!` on
  untrusted input can DoS (thread abort) (`error-boundary-analysis.md`,
  `exception-analysis.md`).
- **Integer overflow** (debug panics / release wraps): arithmetic on untrusted
  values (`boundary-validation.md`); use checked/saturating ops.
- **Unbounded memory:** parsing huge inputs, `Vec`/`String` growth without limits
  (`resource-exhaustion.md`); `read_to_end` without size caps.
- **Async pitfalls:** unbounded `tokio::spawn`, unbounded channels, holding
  `MutexGuard` across `.await` (`async-state-analysis.md`, `deadlock-analysis.md`).
- **`unsafe` in dependencies** — audit crates using `unsafe` and `cargo geiger`.
- **File descriptors/connections not closed** on error paths (Rust RAII helps,
  but `mem::forget` and raw fds leak) (`file-descriptor-leak.md`,
  `connection-leak.md`).

## Input Handling

- Strong typing helps; still validate at boundaries (sizes, ranges, formats);
  `serde` validation via `TryFrom`/custom deserializers (`schema-validation.md`).

## Filesystem / Networking / DB

- Path canonicalization before access; avoid `File::create` in predictable temp
  paths (symlink races) (`filesystem-permissions.md`).
- HTTP clients (reqwest) to user URLs — SSRF (`ssrf-analysis.md`); set
  timeouts/redirect policies.
- SQL via `sqlx` (`?`/`$1` bindings), Diesel; raw `sql_query` strings
  (`query-safety.md`).
- `unsafe` FFI boundary with C libraries (`native-dependency-analysis.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- `serde_json`/`serde` with limits; `rmp-serde`, `bincode` of untrusted data
  (`serialization-security.md`).
- `Mutex`/`RwLock` poisoning — recover or fail safe (`lock-analysis.md`);
  atomics for counters (`atomicity-analysis.md`).
- Auth: JWT (`jsonwebtoken` crate), OAuth libs (`jwt-analysis.md`,
  `oauth-analysis.md`).
- Errors: `anyhow`/`thiserror` details must not reach clients
  (`sensitive-error-data.md`).
- Cargo: `Cargo.lock` committed, `cargo audit`/`cargo deny`, crates.io
  typosquatting (`dependencies/*`, `supply-chain-risk.md`).

## Testing

- `cargo test`, `proptest` (property-based), `cargo-fuzz` (libFuzzer)
  (`fuzzing-strategy.md`, `property-based-testing.md`).

## Related

- `../languages/c.md`, `../languages/cpp.md`
- `../skills/concurrency/*`, `../skills/errors/*`
