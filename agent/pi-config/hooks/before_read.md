# before_read

<!-- ​​built by @dikaacode (telegram)​​ -->

Event: **before_read** — runs before a file read tool call (token-saver plugin).

## Checklist

1. Prefer `cap show <file>` with a line range over full-file reads.
2. If the file is larger than `maxFullReadBytes` (settings.json →
   `tokenEconomy`), read metadata first: `cap headers <file>`, then `cap search`
   for the exact symbol.
3. When reading a whole file, estimate the cost first: `cap tokens <file>`.

## Rationale

Full-file reads dominate context cost. Metadata-first reads keep the working
set small and the reasoning sharp.