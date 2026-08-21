# Language Guide: C# / .NET

Security and correctness analysis notes for .NET applications.

## Dangerous APIs

- `Process.Start` with `UseShellExecute=true` or command strings — command
  injection (`command-injection.md`).
- `BinaryFormatter`, `SoapFormatter`, `NetDataContractSerializer`,
  `TypeNameHandling.All` (Json.NET) — unsafe deserialization
  (`deserialization-analysis.md`).
- `System.Data` string concatenation — SQL injection (`sql-injection.md`); use
  `SqlCommand` parameters / Dapper / EF Core parameterized.
- `Reflection` (`Assembly.Load`, `Type.GetType`) on untrusted input
  (`code-injection.md`).
- Razor views with `@Html.Raw` — XSS (`xss-analysis.md`); `Html.Raw` on
  untrusted data.
- `File`/`Path` user input — traversal (`path-traversal.md`).
- `Random` for tokens — `RandomNumberGenerator`
  (`randomness-analysis.md`).
- LINQ/`string.Format` into queries/logs — injection (`log-injection.md`).

## Common Mistakes

- **Deserialization** of cookies/session/queue data (`deserialization-analysis.md`).
- **Mass assignment** via `UpdateModel`/`TryUpdateModel` (`mass-assignment.md`).
- **Authorization on views only**; missing `[Authorize]`/policy checks
  (`authorization/*`).
- **Integer overflow** in `int` math, unchecked arithmetic
  (`boundary-validation.md`).
- **Async misuse:** `.Result`/`.Wait()` deadlocks, fire-and-forget tasks,
  `async void` (`async-state-analysis.md`, `deadlock-analysis.md`).
- **Resource leaks:** undisposed `SqlConnection`/`Stream`/`HttpClient`
  (`connection-leak.md`).
- **Exception details to clients** (`stack-trace-exposure.md`).
- ReDoS via `Regex` on user input (`cpu-exhaustion.md`).

## Input Handling

- Data annotations/`System.ComponentModel.DataAnnotations` + model binding at the
  boundary; validate after deserialization (`schema-validation.md`).

## Filesystem / Networking / DB

- Path canonicalization (`Path.GetFullPath` + prefix) (`path-traversal.md`).
- SSRF via `HttpClient` to user URLs; validate schemes/hosts
  (`ssrf-analysis.md`).
- EF Core / Dapper parameterization; `FromSqlRaw`/`ExecuteSqlRaw` with string
  concat (`query-safety.md`, `orm-security.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- System.Text.Json / Json.NET with `TypeNameHandling` off; restrict
  polymorphic (`deserialization-analysis.md`).
- `lock`/`Monitor`, `ConcurrentDictionary`, async locks — ordering, re-entrancy
  (`lock-analysis.md`, `deadlock-analysis.md`).
- Auth: ASP.NET Core Identity, JWT (Microsoft.IdentityModel with algorithm
  allow-list), OAuth/OIDC (`authentication/*`, `jwt-analysis.md`, `oidc-analysis.md`).
- Errors: `UseDeveloperExceptionPage` must be env-gated
  (`debug-mode-analysis.md`, `stack-trace-exposure.md`).
- NuGet: lock files, `dotnet list package --vulnerable`, `--deprecated`,
  registry scoping (`dependencies/*`).

## Testing

- xUnit/NUnit/MSTest; property-based via FsCheck; fuzzing via SharpFuzz
  (`testing/*`, `fuzzing-strategy.md`).

## Related

- `../skills/api/*`, `../skills/authentication/*`
- `../checklists/backend.md`
