---
name: command-injection-audit
description: Audit shell construction paths (exec, spawn, child_process, system) for concatenated input; fix with argument arrays and validation whitelists.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, search, show, and verification steps.
metadata:
  category: security
  tags: [command-injection, rce, child_process]
---

# Command Injection A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Find every place where user-controlled data is concatenated into a shell command
(`exec`, `spawn` with `shell: true`, `system`, `popen`, `run`, `sh -c`), prove which
values are attacker-controlled, classify findings as confirmed / probable / possible /
false-positive, and fix each by switching to argument-array invocation and adding
input validation with a strict allow-list.

## Preconditions
- Repository indexed (`cap index --refresh`).
- Trust boundaries identified (request params, filenames, CLI args, environment) that
  can flow into process invocation.

## Workflow
1. Run `cap status` and `cap index --refresh`; confirm runtime with `cap repo` (Node `child_process`, Python `os.system`/`subprocess`, shell scripts, `exec_` in Go/Erlang).
2. `cap search` invocation sinks: `child_process\.exec|execSync|spawn(?:Sync)?|fork\(|execFile|system\(|os\.system|subprocess\.(?:run|call|Popen)|popen\(|\bsh\s+-c|\$\(|backticks in shell scripts`, then narrow with `--path` globs to `*.js|*.ts|*.py|*.sh|*.go`.
3. `cap search` how commands are composed: `\$\{|['"]\s*\+\s*exec|template literals passed to exec/spawn|string concat building argv` — flag `spawn` with `shell: true` and `exec` (both invoke a shell) as higher risk than `spawn` with an argv array.
4. Trace origins with `cap show <file> [--lines a-b]`: is the interpolated value from a request, filename, URL, or env var? Is it quoted, escaped, or allowed-listed (regex/whitelist of permitted characters or literal values)?
5. Classify: **confirmed** — attacker-controlled value reaches a shell-invoking sink; **probable** — sink pattern present and source plausibly controllable, path not fully exercised; **possible** — sink present, source unclear; **false-positive** — value is constant, allow-listed, or passed as an argv array element to `execFile`/non-shell `spawn`.
6. Fix each finding: pass an argument array (`spawn('git', ['commit', msg])`, `execFile`, `subprocess.run([...], shell=False)`) so no shell parses the value; validate against a strict allow-list (safe characters or enumerated literals) at the trust boundary; never add shell escaping as the primary defense.
7. Re-verify every patched call with `cap show`, run `cap lint`, `cap typecheck`, and targeted tests via `cap test`; finish with `cap verify` and `cap diff` scope check.

## Verification
- [ ] All shell-invoking sinks searched across supported languages.
- [ ] Every finding classified; confirmed ones have a traced value origin.
- [ ] Each unescaped concat-to-shell path replaced by argv-array invocation or whitelist validation.
- [ ] Input-validation at every noted trust boundary present (see input-validation skill).
- [ ] `cap lint`, `cap typecheck`, `cap test` pass; `cap verify` green.
- [ ] `cap diff` shows only the intended fixes.

## Failure Handling
- If value origin cannot be traced: classify probable/possible, never confirmed.
- If a value must stay in the command string (legacy constraint): require rigorous allow-list validation, document the residual risk, and recommend the argv refactor.
- If validation would break legitimate inputs: expand the allow-list with evidence, never switch to escaping.
- If no test covers a patched sink: add a regression test with a malicious payload.

## Output Format
Report: findings table (file, line, sink type, command construction, value origin,
classification, severity), fixes applied with file:line evidence, residual-risk list,
and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap test`, `cap verify`, `cap diff`.
- docs/review-engine.md §5 classification rules.