# Language Guide: Ruby

Security and correctness analysis notes for Ruby applications (Rails and non-Rails).

## Dangerous APIs

- `eval`, `send`, `public_send`, `define_method`, `instance_exec` on untrusted
  strings — code injection (`code-injection.md`).
- `system`, `` ` `` backticks, `exec`, `IO.popen`, `Open3` with shell strings —
  command injection (`command-injection.md`).
- `YAML.load` (unsafe, `Psych.load`), `Marshal.load`, `JSON.parse` into
  `ActiveSupport::HashWithIndifferentAccess` with `permit!` — deserialization /
  mass assignment (`deserialization-analysis.md`, `mass-assignment.md`).
- `eval`-style template rendering: ERB with untrusted content — SSTI
  (`template-injection.md`); `html_safe`/`raw` — XSS (`xss-analysis.md`).
- `File`/`Pathname` user input; `send_file` with user paths — traversal
  (`path-traversal.md`).
- `Net::HTTP`/`HTTParty`/`Faraday` to user URLs — SSRF (`ssrf-analysis.md`).
- `rand` for tokens — `SecureRandom` (`randomness-analysis.md`).
- `String#format`/`%` into queries/logs — injection (`log-injection.md`).

## Common Mistakes

- **Mass assignment** via strong parameters misconfiguration (missing
  `permit` allow-list or blanket `permit!`) (`mass-assignment.md`).
- **SQL via string interpolation** — Rails `where("... #{x} ...")`
  (`sql-injection.md`); use bind params `?`.
- **Insecure deserialization** of `Marshal`/`YAML` session cookies
  (`deserialization-analysis.md`).
- **Dynamic `find_by(params)`** on unfiltered params; `find` by id without
  ownership (`idor-analysis.md`).
- **Symbol/string hash confusion**, `fetch` with default that hides errors
  (`exception-analysis.md`).
- **Thread-safety** with global mutable state / class variables in threaded
  servers (`concurrent-state.md`).
- ReDoS via `Regexp.new` on user input (`cpu-exhaustion.md`).
- **`eval`-heavy DSLs** (liquid misconfig, `instance_eval` DSLs) with user input.

## Input Handling

- Strong parameters at the boundary; permit explicit keys only; validate
  types/format (`schema-validation.md`).

## Filesystem / Networking / DB

- `File.expand_path`/`realpath` + containment (`path-traversal.md`).
- SSRF via HTTP clients to user URLs; validate scheme/host/IP
  (`ssrf-analysis.md`).
- ActiveRecord parameterization; `where`/`pluck` with strings; Arel
  (`query-safety.md`, `orm-security.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- Prefer JSON over Marshal; restrict YAML aliases (`serialization-security.md`).
- Rails concurrency: `Rack::Lock`, shared caches, `ActiveRecord` thread safety
  (`concurrent-state.md`).
- Auth: Devise configuration (lockout, pepper), JWT (jwt gem algorithm
  allow-list), OmniAuth provider validation (`authentication/*`,
  `jwt-analysis.md`, `oauth-analysis.md`).
- Errors: sanitize exception messages; `config.consider_all_requests_local=false`
  in prod (`debug-mode-analysis.md`, `stack-trace-exposure.md`).
- Bundler: `Gemfile.lock` committed, `bundle audit`, `--deployment` in prod
  (`dependencies/*`).

## Testing

- RSpec/Minitest; property-based via `rantly`/`mutant` (mutation)
  (`testing/*`, `mutation-testing.md`).

## Related

- `../skills/injection/*`, `../skills/authorization/*`
- `../checklists/backend.md`
