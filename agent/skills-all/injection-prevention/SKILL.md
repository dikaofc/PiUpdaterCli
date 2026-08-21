---
name: injection-prevention
description: Prevent injection attacks — SQL, NoSQL, command, template, header injection. Use when writing queries, shell calls, or templating user input.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Injection Prevention

## The rule
**Never build code-interpreter strings from user input.** Instead: parameterize, bind, or strictly-validate+whitelist into a non-interpreted form.

## SQL
- Parameterized/prepared queries always: `?`/`$1` placeholders, ORM binding (`sql.md`). Never string-concat: `WHERE id = '` + user + `'` ⇒ the classic.
- Fail: `LIMIT`/`ORDER BY` from UI — whitelist maps (`{ asc, desc }`), not raw pass-through; `IN (...)` from array — expand placeholders per element.
- NoSQL: MongoDB `$where`/`$regex` params — sanitize operators (`{ $ne: null }` in JSON payload = auth bypass classic).

## Command injection
- No `exec`/`child_process.exec`/`System()`/`os.system` with interpolated input. Prefer: `execFile`/`spawn` with argv array (no shell), or `shlex`-quote only when shell unavoidable — argv-array is the fix.
- `eval`/`new Function`/`template render` of untrusted — remove or sandbox (CFG-free VM, not regex-filtering — blocklists lose).
- Example safest: `spawn('git', ['add', filename])` where filename validated as simple name.

## Header/SSI
- User input in `Location`/`Set-Cookie`/response-header: validate (URL allowlist for redirects — open redirect ≠ CSRF), escape CR/LF (`\r\n`) — header injection = response splitting.
- Server-side includes/imports/templates: whitelist, never path-from-input (`load(url)`) → SSRF (see `api-validation`).

## Defense stack (belt+suspenders)
- Validation at boundary (types, length, charset).
- Prepared statements (structure fixed).
- Whitelist/deny at output.
- Least-privilege DB roles (app role can't `DROP`; no GRANT to attacker reachable).

## Automated checks
- Semgrep/CodeQL rules for `+`/f-string concat in SQL/exec/HTML; grep for `exec(`/`eval`/`raw` patterns; fuzz boundary fields.
- Tests: classic payloads (`' OR 1=1--`, `; rm -rf`, `<script>`, `$ne`).

## Checklist
- [ ] Parameterized everywhere textual; no concat SQL
- [ ] No user input into exec/eval/template-exec
- [ ] Headers/redirects validated + CR/LF stripped
- [ ] Least-privilege DB/app roles
- [ ] Injection tests cover SQL/command/NoSQL/template