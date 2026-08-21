# Language Guide: PHP

Security and correctness analysis notes for PHP applications.

## Dangerous APIs

- `eval`, `assert` with strings, `preg_replace` with `/e`, `create_function`,
  `unserialize` — code injection / unsafe deserialization
  (`code-injection.md`, `deserialization-analysis.md`).
- `system`, `exec`, `shell_exec`, `` ` `` backticks, `passthru`, `proc_open` —
  command injection (`command-injection.md`).
- String-concatenated SQL with `mysqli`/`PDO` — SQL injection
  (`sql-injection.md`); use prepared statements.
- `include`/`require` with user-controlled paths — LFI/RFI
  (`path-traversal.md`).
- `echo`/`print` of user data without escaping — XSS (`xss-analysis.md`);
  `htmlspecialchars` with correct flags (`ENT_QUOTES`, charset).
- `file_get_contents`/`curl` to user URLs — SSRF (`ssrf-analysis.md`).
- `rand`/`mt_rand` for tokens — `random_bytes`/`random_int`
  (`randomness-analysis.md`).
- `extract()`, `parse_str()` (with array input), `$$var` — variable injection /
  mass assignment (`mass-assignment.md`).

## Common Mistakes

- **`unserialize` on cookies/session/user data** — RCE via gadget chains
  (`deserialization-analysis.md`).
- **Loose comparison** `==` (`"0" == "abc"`, `0 == "foo"`) — auth bypasses and
  type confusion (`type-confusion.md`); use strict `===`.
- **`$_GET`/`$_POST`/`$_REQUEST` arrays trusted** without validation.
- **MD5/SHA1 password hashing** (`password-storage.md`); use `password_hash`.
- **Session fixation** (`session_fixation.md`); regenerate IDs.
- **File uploads** to web root with original names (`file-upload-security.md`).
- **Error display:** `display_errors=On` in prod leaks paths/stack
  (`stack-trace-exposure.md`); `error_reporting(E_ALL)` in prod logs.
- ReDoS (`cpu-exhaustion.md`); `strtotime`-style type juggling.

## Input Handling

- Filter input, escape output; validate types with strict comparisons; use
  `filter_var`/validation libs (`schema-validation.md`).

## Filesystem / Networking / DB

- Canonicalize paths (`realpath`) + containment (`path-traversal.md`).
- SSRF via curl to user URLs; block internal/metadata ranges
  (`ssrf-analysis.md`).
- PDO prepared statements / ORM (Laravel Eloquent, Doctrine) with bindings;
  avoid `DB::raw`/`whereRaw` concat (`query-safety.md`, `orm-security.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- `json_decode` depth limits; `unserialize` with allowed_classes=[] where
  possible (`serialization-security.md`).
- PHP-FPM/opcache: shared state less common; filesystem races via `file_put_contents`
  (`race-condition.md`).
- Auth: `password_hash`/`password_verify`, session hardening, JWT (firebase/php-jwt
  algorithm allow-list) (`authentication/*`, `jwt-analysis.md`).
- Errors: never expose `$_SERVER`, `debug_backtrace`, or exceptions
  (`sensitive-error-data.md`).
- Composer: `composer.lock` committed, `composer audit`, `--no-dev` in prod,
  packagist typosquatting (`dependencies/*`).

## Testing

- PHPUnit; property-based with `php-coveralls`? (use Pest/PHPUnit + fuzzing via
  `php-fuzzer` style harnesses) (`testing/*`).

## Related

- `../skills/injection/*`, `../skills/session/*`
- `../checklists/backend.md`
