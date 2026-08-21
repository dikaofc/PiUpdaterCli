# Language Guide: Java

Security and correctness analysis notes for Java applications.

## Dangerous APIs

- `Runtime.exec`, `ProcessBuilder` with string commands/shell — command injection
  (`command-injection.md`); use argv arrays.
- `ObjectInputStream.readObject` — unsafe deserialization
  (`deserialization-analysis.md`); use `ObjectInputFilter` or JSON.
- `java.sql` string concatenation — SQL injection (`sql-injection.md`); use
  `PreparedStatement`.
- Reflection `Class.forName`/`newInstance` on untrusted strings — code injection
  (`code-injection.md`).
- JSP/`jsp:include`/expression language — template/expression injection
  (`template-injection.md`, `expression-injection.md`).
- `ProcessBuilder` with env leakage; `File`/`Path` user input — traversal
  (`path-traversal.md`).
- `java.util.Random` for tokens — use `SecureRandom` (`randomness-analysis.md`).
- Logging `String.format` with user input — log injection (`log-injection.md`).

## Common Mistakes

- **Deserialization of untrusted input** (RMI, session storage, MQ messages)
  (`deserialization-analysis.md`).
- **Mass assignment** with Spring `@ModelAttribute`/`BeanUtils.copyProperties`
  (`mass-assignment.md`).
- **Authorization on UI only**; missing method-level `@PreAuthorize`
  (`authorization/*`).
- **Integer overflow** in arithmetic/limits (`boundary-validation.md`).
- **Static mutable state** across requests (`concurrent-state.md`).
- **Resource leaks:** unclosed `Connection`/`Stream`/`Reader` in error paths
  (`connection-leak.md`, `file-descriptor-leak.md`).
- **Exceptions to clients:** `printStackTrace`, returning exception messages
  (`stack-trace-exposure.md`).
- ReDoS via `Pattern.compile` on user input (`cpu-exhaustion.md`).

## Input Handling

- Bean Validation (`@Valid`, jakarta validation) at the boundary; never trust
  DTO fields after conversion (`schema-validation.md`).

## Filesystem / Networking / DB

- Path canonicalization (`Path.toRealPath`) + containment
  (`path-traversal.md`).
- SSRF via `HttpClient`/`RestTemplate` to user URLs; validate hosts
  (`ssrf-analysis.md`).
- JDBC `PreparedStatement`; JPA/Hibernate `nativeQuery`, `@Query` with string
  concat — parameterized only (`query-safety.md`, `orm-security.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- Jackson `enableDefaultTyping`/polymorphic — unsafe (`deserialization-analysis.md`).
- `synchronized`/`ConcurrentHashMap` misuse; lock ordering → deadlock
  (`deadlock-analysis.md`); `volatile` misuse (`atomicity-analysis.md`).
- Auth: Spring Security filters, JWT (jjwt with algorithm allow-list), OAuth
  (`authentication/*`, `jwt-analysis.md`).
- Errors: controller advice should sanitize; log full, return generic
  (`error-boundary-analysis.md`).
- Maven/Gradle: lockfiles (Gradle `dependency-lock`, Maven enforcer), `OWASP
  Dependency-Check`, `dependency-confusion` registry config
  (`dependencies/*`).

## Testing

- JUnit 5, Mockito; property-based with jqwik; fuzzing with Jazzer
  (`testing/*`, `fuzzing-strategy.md`).

## Related

- `../languages/kotlin.md`
- `../skills/authentication/*`, `../skills/errors/*`
