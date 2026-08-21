# Language Guide: Python

Security and correctness analysis notes for Python (web, services, tooling).

## Dangerous APIs

- `eval`, `exec`, `compile`, `pickle.loads`, `yaml.load` (unsafe), `subprocess`
  with `shell=True` or string args — code/command injection
  (`code-injection.md`, `command-injection.md`, `deserialization-analysis.md`).
- `os.system`, `os.popen`, `subprocess.Popen(shell=...)`.
- `open()`/`os.*` with user paths — traversal (`path-traversal.md`); always
  `os.path.realpath` + containment check.
- Templating: Jinja2 autoescape off, `|safe`, `format` with `__class__` — SSTI
  (`template-injection.md`).
- `cgi`/legacy HTML rendering; `markupsafe.Markup` misuse — XSS
  (`xss-analysis.md`).
- `random` module for security tokens — use `secrets`
  (`randomness-analysis.md`).
- `int("1e3")`, float comparison for money (`price-integrity.md`).

## Common Mistakes

- **Parameterized queries via %-formatting/f-strings** instead of `?`/`%s`
  placeholders — SQL injection (`sql-injection.md`).
- **Mutable default arguments**, shared globals across requests in threaded
  servers (`concurrent-state.md`).
- **Exception handling** `except: pass` swallowing; `except Exception` catching
  `KeyboardInterrupt`/`SystemExit`; bare `raise` in `except` losing context
  (`exception-analysis.md`).
- **Integer bounds:** arbitrary precision can mask overflow bugs; use
  `math.isclose`/`Decimal` for money (`price-integrity.md`).
- Unicode normalization mismatches (`unicode-handling.md`).
- Regex ReDoS (`cpu-exhaustion.md`).

## Input Handling

- Validate with typed schemas (Pydantic, marshmallow, dataclasses + guards);
  reject unknown fields (`schema-validation.md`, `mass-assignment.md`).
- Watch `**kwargs` and `__init__` mass assignment (Django `fields` vs
  `exclude`) (`mass-assignment.md`).

## Filesystem / Networking

- `tempfile` misuse; symlink attacks in world-writable dirs
  (`filesystem-permissions.md`).
- SSRF via `requests`/`urllib` to user URLs; disable redirects where needed;
  validate schemes/hosts (`ssrf-analysis.md`, `url-validation.md`).
- `urllib`/`http.client` without timeouts → hang/exhaustion
  (`timeout-analysis.md`).

## Database

- DB-API placeholders (`sqlite3` `?`, psycopg `%s`, MySQLdb `%s`); ORM raw
  (`SQLAlchemy text()`, `execute` strings) bypasses (`query-safety.md`,
  `orm-security.md`).
- MongoDB NoSQL operator injection (`nosql-injection.md`).

## Serialization / Concurrency / Auth / Errors / Dependencies

- `pickle`/`yaml.load` untrusted → RCE; prefer `yaml.safe_load`, JSON
  (`deserialization-analysis.md`).
- GIL reduces but does not remove races; asyncio shared state
  (`async-state-analysis.md`).
- Auth: Django/Python sessions, JWT (PyJWT `algorithms` allow-list), passlib/Argon2
  (`authentication/*`, `jwt-analysis.md`).
- Errors: never return `str(exc)`/tracebacks to clients
  (`stack-trace-exposure.md`).
- pip: `requirements.txt`/`poetry.lock`/`uv.lock` pinned with hashes; `pip-audit`
  (`dependencies/*`).

## Testing

- pytest + hypothesis (property-based), django test client / fastapi TestClient;
  fuzzing with `atheris`/`python-afl` (`testing/*`, `fuzzing-strategy.md`).

## Related

- `../skills/injection/*`, `../skills/errors/*`
- `../checklists/backend.md`
