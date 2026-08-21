# core

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Base plugin for the Claude Agent Platform: repository intelligence, file
exploration, the interactive file picker, and the deterministic `cap` tool
layer. Every other plugin depends on `core >= 1.0.0`.

## What It Does

- Builds and maintains the repository index (`cap index`) and exposes
  exploration (`cap explore`), content search (`cap search`), file reading
  (`cap show`), and file picking (`cap pick`).
- Provides repository intelligence (`cap repo`), diffs with impact analysis
  (`cap diff`), file metadata (`cap headers`), conflict detection
  (`cap watch`), and the audit trail (`cap audit`).
- Supplies `status`, `files`, `pick`, and `config` commands, the `explore` and
  `explain` skills, and the `explorer` specialist agent.
- Registers `before_read`, `before_write`, and `after_write` hooks so file
  access is logged and gated.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: true |
| shell | execute: true |
| network | access: false |
| database | read: false, write: false |
| git | read: true, write: true |

## What It Grants

Read/write access to the working tree, shell execution for the `cap` tool
layer, and git read/write for repository analysis and audit tools. Network and
database access are **not** granted.

## Enable / Disable

`cap plugins enable core` / `cap plugins disable core`. Core is normally
installed automatically as a dependency of other plugins; disabling it also
disables dependent plugins.

## Limitations

- No network or database access; external lookups require a network-enabled
  plugin.
- Arbitrary shell writes are not exposed: the `cap` CLI only provides policed
  wrappers; the host agent's shell remains the only write-capable shell.
