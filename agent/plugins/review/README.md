# review

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Read-only code review: correctness, security, and performance review workflows
that produce structured findings (severity, category, confidence).

## What It Does

- `review`, `risk`, and `rollback` commands; `review`, `security-review`, and
  `performance-review` skills.
- `reviewer`, `security-reviewer`, and `performance-reviewer` specialist
  agents.
- Runs the review engine (`cap review`), scores change risk (`cap risk`), and
  inspects diffs (`cap diff`).
- Registers `before_review` and `after_review` hooks.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: false |
| shell | execute: false |
| network | access: false |
| database | read: false, write: false |
| git | read: true, write: false |

## What It Grants

Strictly read-only access to files and git history (git-write is disabled).
No shell execution, network, or database access.

## Enable / Disable

`cap plugins enable review` / `cap plugins disable review`. Installs `core`
automatically (dependency `core >= 1.0.0`).

## Limitations

- Cannot modify files or commit; findings are advisory only.
- `rollback` is advisory too: it proposes a rollback from the audit trail but
  cannot write — pair with the `git` plugin to actually execute it.
