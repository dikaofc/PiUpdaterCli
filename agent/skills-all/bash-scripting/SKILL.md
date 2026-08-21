---
name: bash-scripting
description: Write robust bash scripts — set -euo pipefail, argument parsing, error handling, portability, safety.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Bash Scripting

## Header (every script)
```bash
#!/usr/bin/env bash
set -euo pipefail   # fail fast, no silent failures, safe pipes
IFS=$'\n\t'
```
- `-e` exits on error; `-u` catches typos/unset vars; `-o pipefail` surfaces mid-pipe failures (e.g. `grep | awk`).
- Scripts needing full portability across bash/zsh/sh: stay POSIX where possible; bash-only features OK if shebang is bash.

## Structure
- `main "$@"` at bottom, functions above; `usage()` on error and always `exit 1` on arg parse fail.
- Long options: `getopts` (POSIX short) or a `while [[ $# -gt 0 ]]` case loop — no GNU getopt dependency.
- Print errors to stderr: `>&2` on every message; exit codes ≠ 0 for every failure path.
- Local kills: `trap 'rm -f "$tmpfile"' EXIT` for temp files; `trap 'kill $pid' TERM` for child processes — scripts must not leak tempfiles or orphans.

## Danger zones
- **Quote everything**: `"$@"`, `"$1"`, `"$var"` — unquoted = word splitting + globbing on user data (injection).
- `eval` — never on user input; arithmetic `(( ))` only on validated ints.
- Reading user input into `find`/`rm`/`grep -r` paths — validate `[[ $p =~ ^[a-zA-Z0-9_./-]+$ ]]` before filesystem ops.
- `set -u` + `$@` unset edge — `"${@:-}"` guard when args optional.
- No `IFS` juggling mid-loop without restore.

## Portability
- `mktemp` for files; `command -v` for tool checks (not `which`); `$(...)` not backticks; `[[ ]]` bash / `[ ]` POSIX.
- Line endings LF; no leading/trailing whitespace changes (diff noise).
- Newlines in filenames: iterate `find ... -print0 | while read -d ''` — never `for f in $(ls)`.

## Checklist
- [ ] set -euo pipefail; quoting everywhere
- [ ] Args validated; usage() + exit 1
- [ ] Errors to stderr with context
- [ ] Traps clean temp/children
- [ ] No eval on user data