# database

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Optional read-only database exploration. **Disabled by default** — requires
explicit enable and an MCP database adapter.

## What It Does

- `explore` skill for inspecting schemas and data.
- `db_schema` tool — a placeholder provided through the MCP database adapter.
- Read-only by default: queries may only read schema and data, never write.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: false, write: false |
| shell | execute: false |
| network | access: false |
| database | read: true, write: false |
| git | read: false, write: false |

## What It Grants

Database **read** only. No filesystem, shell, network, or git access. Write
access is deliberately not granted; it requires a higher permission set.

## Enable / Disable

The plugin ships disabled. There is **no `"enabled"` field in `plugin.json`**;
disabled state is stored in the platform settings. Enable explicitly with:

```
cap plugins enable database
```

then configure the MCP database adapter. Disable with:

```
cap plugins disable database
```

## Limitations

- Read-only: database write requires a higher permission (database write)
  that this plugin does not declare.
- The `db_schema` tool only exists once the MCP database adapter is connected.
