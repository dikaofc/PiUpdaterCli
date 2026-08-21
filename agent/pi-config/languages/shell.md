# Language Guide: Shell

Security and correctness analysis notes for shell scripts (bash, sh, zsh, POSIX).

## Dangerous Patterns

- **Unquoted variable expansion** — word splitting and glob injection:
  `rm $files`, `cat $file` — arbitrary file operations and argument injection
  (`command-injection.md`).
- **`eval` on constructed strings** — code injection (`code-injection.md`).
- **`$(...)` / backticks in strings** — command substitution injection.
- **Paths from input** (`cd $DIR`, `cp ... $dest`) — traversal
  (`path-traversal.md`).
- **`curl`/`wget` to user URLs** — SSRF (`ssrf-analysis.md`).
- **Reading secrets via `cat $SECRET_FILE` into variables that get logged.**
- **`find -exec`/`xargs` with user input.**
- **`printf` with format specifiers in user data** — format issues.

## Common Mistakes

- `[ "$x" = "$y" ]` vs `[[ ]]` differences; quoting across shells.
- **Missing `set -euo pipefail`** — silent failures propagate
  (`exception-analysis.md`).
- **`rm -rf` with variables** — catastrophic if variable empty/unset.
- **Glob expansion on attacker-controlled dirs.**
- **Temp files in predictable locations** — symlink attacks
  (`filesystem-permissions.md`).
- **Escaping errors:** backslash escaping in double quotes is incomplete.
- **Exit code handling** in pipelines (only last command's status).

## Input Handling

- Quote everything: `"$var"`; use arrays for args; never eval untrusted strings.
- Validate inputs (patterns, lengths) before use.

## Filesystem / Networking

- Use `mktemp -d` for temp dirs; set `trap` cleanup
  (`file-descriptor-leak.md`, `disk-exhaustion.md`).
- Network: prefer tools with strict URL validation; block internal ranges for
  user-provided URLs (`ssrf-analysis.md`).

## Concurrency / Errors / Dependencies

- Race-prone: `if [ -f file ]; then use file` — TOCTOU (`toctou-analysis.md`).
- Errors: check every command's status; log to stderr; no secrets in output.
- Dependencies: pin script versions; verify downloaded scripts (checksums)
  (`supply-chain-risk.md`, `package-integrity.md`).

## Testing

- ShellCheck (lint); bats for unit tests; test error paths and quoting
  (`testing/*`, `negative-testing.md`).

## Related

- `../skills/injection/command-injection.md`
- `../skills/infrastructure/process-permissions.md`
- `../skills/reliability` concerns in `../skills/errors/*`
