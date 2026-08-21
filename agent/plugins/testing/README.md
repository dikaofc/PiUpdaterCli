# testing

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Targeted test, lint, typecheck, and build workflows through the policed `cap`
wrapper tools (no arbitrary shell commands).

## What It Does

- `test` command and `test` skill.
- `tester` specialist agent.
- Runs `cap test`, `cap lint`, `cap typecheck`, `cap build`, and `cap verify`.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: false |
| shell | execute: false |
| network | access: false |
| database | read: false, write: false |
| git | read: false, write: false |

## What It Grants

Read-only access to the working tree so tests, linters, typecheckers, and
builds can run. No arbitrary shell execution: only the policed wrapper
commands are available, so this plugin is safe to keep enabled.

## Enable / Disable

`cap plugins enable testing` / `cap plugins disable testing`. Installs `core`
automatically (dependency `core >= 1.0.0`).

## Limitations

- No write access; if a build writes artifacts into the tree, grant
  filesystem write in the effective config.
- No network access; tests with external dependencies may fail offline.
