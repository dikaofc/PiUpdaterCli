# git

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Git operations with structured, auditable commits: diff review, commit
proposals, rollback, and the audit trail.

## What It Does

- `git`, `rollback`, and `commit` commands; the `commit` command is routed
  through the `cap commit` tool.
- `review` skill and `reviewer` specialist agent.
- Diffs (`cap diff`), commit proposals (`cap commit`), rollback from the audit
  trail (`cap rollback`), and audit inspection (`cap audit`).
- Registers `before_commit`, `after_commit`, `before_write`, and `after_write`
  hooks for commit-time gating and logging.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: false |
| shell | execute: true |
| network | access: false |
| database | read: false, write: false |
| git | read: true, write: true |

## What It Grants

Full git read/write (commits, rollbacks, audits) and shell execution for the
`cap` git wrappers. Filesystem writes are not granted directly; changes enter
git only via `cap commit`.

## Enable / Disable

`cap plugins enable git` / `cap plugins disable git`. Installs `core`
automatically (dependency `core >= 1.0.0`).

## Limitations

- Commits are proposals: structured and audited, and inspectable before
  applying with `cap commit --dry-run`.
- No filesystem write permission, so staging untracked generated files may
  require the `coding` plugin or an explicit settings override.
