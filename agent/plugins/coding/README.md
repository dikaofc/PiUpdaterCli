# coding

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Structured software change workflows: implementation, refactoring, debugging,
explanation, and documentation, built on the `cap` plan/verify/risk tool layer.

## What It Does

- `implement`, `refactor`, `debug`, `plan`, `dry-run`, and `document` commands.
- `implement`, `refactor`, `debug`, `explain`, and `document` skills.
- `coder` and `debugger` specialist agents.
- Plans changes (`cap plan`), runs the verification pipeline (`cap verify`),
  and scores change risk (`cap risk`).

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: false, write: true |
| shell | execute: true |
| network | access: false |
| database | read: false, write: false |
| git | read: false, write: false |

## What It Grants

File **write** access (implementation and refactor edits) and shell
**execute** (host shell for the coding agents). Read access is contributed by
the `core` dependency in the effective permission matrix
(`cap permissions`). Network, database, and direct git access are not granted.

## Enable / Disable

`cap plugins enable coding` / `cap plugins disable coding`. Installs `core`
automatically (dependency `core >= 1.0.0`).

## Limitations

- Declares write without read; reads rely on `core`. If `core` is missing,
  dependency checks fail at install time.
- No git access declared; if risk analysis over staged diffs is needed, grant
  git read in the effective config or use `core`'s `cap diff`.
