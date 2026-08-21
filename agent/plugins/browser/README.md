# browser

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Optional browser exploration: fetch and explain web pages. **Disabled by
default** — requires explicit enable and an MCP browser adapter (phase 2).

## What It Does

- `explore` command and `explain` skill for web content.
- `http_request` tool — a placeholder that becomes functional once the MCP
  browser adapter (phase 2) is configured on the platform.

## Permissions Declared

| Permission | Value |
|---|---|
| filesystem | read: true, write: false |
| shell | execute: false |
| network | access: true |
| database | read: false, write: false |
| git | read: false, write: false |

## What It Grants

Network access (HTTP requests) and read-only filesystem. No shell, database,
or git access.

## Enable / Disable

The plugin ships disabled. There is **no `"enabled"` field in `plugin.json`**;
disabled state is stored in the platform settings. Enable explicitly with:

```
cap plugins enable browser
```

then configure the MCP browser adapter. Disable with:

```
cap plugins disable browser
```

## Limitations

- Requires the MCP browser adapter (phase 2); `http_request` is a placeholder
  until the adapter is connected.
- Network access is broad — review the adapter's allow-list before enabling.
