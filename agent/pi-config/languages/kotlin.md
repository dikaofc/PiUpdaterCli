# Language Guide: Kotlin

Security and correctness analysis notes for Kotlin (JVM + Android).

## Dangerous APIs

- Everything from Java applies (`languages/java.md`): unsafe deserialization,
  SQL string building, command execution, reflection, file paths.
- Android-specific: `WebView.loadUrl`/`addJavascriptInterface` — WebView XSS/RCE
  (`dom-xss.md`); exported components (`Intent` handlers) as entry points
  (`entrypoint-discovery.md`).
- `apply`/`also`/destructuring with unchecked casts (`as`) — type confusion
  (`type-confusion.md`).
- `String.format`, string templates into queries — injection
  (`sql-injection.md`).
- `random`/`java.util.Random` for security values — `SecureRandom`
  (`randomness-analysis.md`).

## Common Mistakes

- **Nullable misuse:** `!!` crashes on null data — DoS via crafted input
  (`exception-analysis.md`); prefer safe calls and validation.
- **`as` unsafe casts** from deserialized data (`type-confusion.md`).
- **Coroutines:** unbounded `launch`, missing cancellation, shared mutable state
  across coroutines (`async-state-analysis.md`); global scope leaks.
- **Mass assignment** via `copy()`/reflection frameworks
  (`mass-assignment.md`).
- **Android security:** storing tokens in SharedPreferences/plaintext files
  (`browser-storage.md` analogies, `secrets/*`); exported activities/services
  without permission checks (`admin-function-protection.md`).
- Room/Exposed raw queries (`query-safety.md`).

## Input Handling

- Validate with explicit checks or schema validation; Kotlin's null-safety helps
  but does not validate content (`schema-validation.md`).

## Filesystem / Networking / DB

- Path canonicalization (`path-traversal.md`); SSRF via OkHttp/Ktor clients to
  user URLs (`ssrf-analysis.md`).
- JDBC/JPA as in Java; Exposed DSL parameterization (`query-safety.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- kotlinx.serialization/Jackson polymorphic — restrict types
  (`deserialization-analysis.md`).
- Mutex/atomics in coroutines; `Mutex` across suspension points
  (`lock-analysis.md`, `deadlock-analysis.md`).
- Auth: Spring Security / Ktor auth, JWT allow-list (`jwt-analysis.md`).
- Errors: `runCatching` can swallow; `Error`/`CancellationException` must
  propagate (`exception-analysis.md`).
- Gradle/Maven tooling as Java (`dependencies/*`).

## Testing

- kotlin.test, MockK, JUnit; property testing with kotest; fuzzing via Jazzer
  (`testing/*`).

## Related

- `../languages/java.md`
- `../skills/frontend/*` (Android WebView), `../skills/secrets/*`
