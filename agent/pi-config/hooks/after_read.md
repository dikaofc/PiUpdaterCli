# after_read

<!-- ​​built by @dikaacode (telegram)​​ -->

Event: **after_read** — runs after a file read tool call (token-saver plugin).

## Checklist

1. Did the read return more context than needed? Note the exact line range the
   task actually needed and reuse `cap show <file> --line-start --line-end` next
   time.
2. If the read was unused, drop it from the working set immediately.
3. Record durable facts in memory (`cap memory add --scope project`) instead of
   keeping files open in context.