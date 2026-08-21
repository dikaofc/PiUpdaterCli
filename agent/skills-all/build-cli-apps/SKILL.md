---
name: build-cli-apps
description: Build CLI applications — argument parsing, stdout/stderr discipline, colors/TTY, exit codes, interactivity, structs/log.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CLI Apps

## Interface contract
- `--help`/`-h` always; short+long flags; `--version`; positional args; env-override for config (`GOOGLE_API_KEY`).
- Output: results → stdout (scriptable), diagnostics/logs/errors → stderr; `--quiet`/`-q` and `--verbose`/`-v` toggles; JSON output flag (`--json`) for machine consumption (stable schema).
- Exit codes: 0 success, 1 runtime error, 2 usage error (argparse convention); distinguish no-match vs failure (e.g. 3 empty result) documented.
- TTY detection: color only when `isatty(stdout)` (`NO_COLOR` respected); piped output stays plain for grep/pipes.

## Parsing (don't hand-roll)
- Node: `commander`/`yargs`; Go: `cobra`/`urfave/cli`; Python: `argparse`/`click`; shell: getopts — parse strictly, error early with usage hint.

## UX
- Progress: spinner for unknown duration, progress bar for known; update ≤ 20Hz; write progress to stderr so stdout stays clean.
- Interactivity: `--yes/-y` for prompts in automation; default answers when `stdin` not TTY.
- Failure messages actionable: what went wrong + what to do next ("file not found: check --config path").
- Paginate long trivia output (`less`/pager when interactive); truncate + `--full`.

## Composition & robustness
- Idempotent where semantics allow (`--force`); no destructive default (dry-run first).
- Timeouts on network ops; signal handling (SIGINT → cleanup temp files, exit 130).
- Log destructuring: `--log-level debug`; default `info` plain lines, debug adds context.
- Size sanity: startup < 50ms (no big deps on import path); help/`--help` runs without side effects.

## Checklist
- [ ] stdout data / stderr logs separated
- [ ] Exit codes + JSON mode documented
- [ ] --help full; flags parse strict
- [ ] TTY-aware colors; NO_COLOR
- [ ] No side effects in --help/--version