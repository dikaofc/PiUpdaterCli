# security

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Security review and dependency auditing: scanning code and manifests for
vulnerabilities and risky dependencies.

## What It Does

- `review` command; `security-review` and `dependency-audit` skills.
- `security-reviewer` and `dependency-agent` specialist agents.
- Searches code (`cap search`) and runs the review engine (`cap review`).

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: false |
| shell | execute: false |
| network | access: false |
| database | read: false, write: false |
| git | read: true, write: false |

## What It Grants

Read-only access to files and git history for static analysis. No writes, no
shell execution, no network, no database access.

## Enable / Disable

`cap plugins enable security` / `cap plugins disable security`. Installs
`core` automatically (dependency `core >= 1.0.0`).

## Limitations

- Read-only: findings and audit advice only; remediation requires the
  `coding` or `git` plugins.
- No network by default; live vulnerability-feed lookups during
  `dependency-audit` need network access enabled manually in settings.
