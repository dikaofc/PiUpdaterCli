# Language Guide: C

Security and correctness analysis notes for C code (libraries, embedded,
services).

## Dangerous APIs

- **Memory unsafe functions:** `strcpy`, `strcat`, `sprintf`, `vsprintf`,
  `gets`, `scanf("%s")` — buffer overflows (`memory`/`errors` concerns).
- `malloc`/`calloc` without size checks; `realloc` failure handling.
- Pointer arithmetic, array indexing without bounds — OOB read/write.
- `system`, `popen`, `execl` with strings — command injection
  (`command-injection.md`).
- `memcpy`/`strncpy` misuse (missing null-termination; off-by-one).
- `format string` bugs: `printf(user_input)` — arbitrary read/write
  (`format` handling).
- `setuid`/`setgid` misuse — privilege issues (`process-permissions.md`).
- `mkstemp` vs `tmpnam`/`mktemp` — symlink races
  (`filesystem-permissions.md`).

## Common Mistakes

- **Integer overflow** before allocation (`boundary-validation.md`) — size
  arithmetic on untrusted values.
- **Use-after-free / double-free** — lifetime management
  (`memory-leak-analysis.md`, reliability).
- **Missing null checks** on allocations and function returns.
- **TOCTOU** on file/stat checks (`toctou-analysis.md`).
- **Uninitialized memory** use.
- **Locale/encoding issues** in string handling (`unicode-handling.md`).
- **Off-by-one** in loops and buffer sizes.

## Input Handling

- Bounds-check every read; use safe APIs (`snprintf`, `strlcpy` where available);
- Validate sizes before operations; treat all external input as hostile.

## Filesystem / Networking

- Canonicalize paths (`realpath`); verify permissions before/after open with
  safe patterns (`filesystem-permissions.md`).
- Socket code: validate lengths, handle partial reads, set timeouts
  (`timeout-analysis.md`), check return codes.

## Concurrency

- Data races (`race-condition.md`); `pthread` locking discipline
  (`deadlock-analysis.md`); volatile misuse (`atomicity-analysis.md`).

## Errors / Dependencies

- Errors: propagate and log, never print internal state (`sensitive-error-data.md`).
- Libraries: audit CVE-tracked libs (OpenSSL, zlib, libxml2, image libs) with
  reachability analysis (`native-dependency-analysis.md`).

## Testing

- Sanitizers: ASan/UBSan/TSan/Valgrind; fuzzing with libFuzzer/AFL++
  (`fuzzing-strategy.md`); property tests with `cprover`-style tools where
  available.

## Related

- `../languages/cpp.md`, `../languages/rust.md`
- `../skills/errors/*`, `../skills/concurrency/*`
