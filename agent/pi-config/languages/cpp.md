# Language Guide: C++

Security and correctness analysis notes for C++ code.

## Dangerous APIs

- C-string functions (`strcpy`, `sprintf`, `gets`) — buffer overflows; prefer
  `std::string`, `std::string_view` with bounds.
- Raw pointers/`new`/`delete` misuse; prefer smart pointers (`unique_ptr`,
  `shared_ptr`) — UAF/double-free.
- `reinterpret_cast`/`const_cast`/C-style casts — type confusion
  (`type-confusion.md`).
- `std::vector::at` vs `operator[]`; iterator invalidation.
- `system`, `popen` — command injection (`command-injection.md`).
- `printf` with user format — format string issues.
- `gets`-style reads; `std::cin >>` into fixed buffers.
- Deserialization of `std::istream`/protobuf/msgpack untrusted data without
  limits (`serialization-security.md`).

## Common Mistakes

- **Integer overflow** in size arithmetic before allocation (`boundary-validation.md`).
- **Undefined behavior** from signed overflow, UB compilers optimize away checks.
- **Exception unsafety:** resources leak on exceptions (`exception-analysis.md`).
- **Copy/move semantics bugs**, dangling references.
- **Multi-threading:** data races, deadlocks from lock ordering
  (`race-condition.md`, `deadlock-analysis.md`); `static` initialization order.
- **Missing bounds checks** on user-controlled indices (`boundary-validation.md`).
- ReDoS via `std::regex` (`cpu-exhaustion.md`).

## Input Handling

- Bounds-check all input; prefer ranges (C++20 ranges), `std::span` with sizes;
  validate sizes/lengths before allocation.

## Filesystem / Networking

- `std::filesystem` canonical paths; avoid `tmpnam`/`mktemp`
  (`path-traversal.md`, `filesystem-permissions.md`).
- Network code: handle partial reads/writes, timeouts (`timeout-analysis.md`).

## Concurrency

- `std::mutex`/`shared_mutex` discipline; `std::atomic`; lock ordering
  (`lock-analysis.md`, `atomicity-analysis.md`).

## Errors / Dependencies

- Error handling: exceptions vs error codes consistent; never leak internals
  (`sensitive-error-data.md`).
- Libraries: OpenSSL, zlib, libxml2, image/video libs — reachability analysis
  (`native-dependency-analysis.md`).

## Testing

- Sanitizers (ASan/UBSan/TSan), Valgrind; fuzzing with libFuzzer/AFL++
  (`fuzzing-strategy.md`); property-based with RapidCheck/`proptest`-style.

## Related

- `../languages/c.md`, `../languages/rust.md`
- `../skills/memory` concerns in `../skills/errors/*`
