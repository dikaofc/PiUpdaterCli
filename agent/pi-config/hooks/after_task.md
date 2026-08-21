# after_task

<!-- ​​built by @dikaacode (telegram)​​ -->

Event: **after_task** — runs after the task is done or failed.

## Checklist

1. Close the task: `cap task done <id>` or `cap task fail <id>`.
2. Summarize durable lessons in memory: `cap memory add --scope project`.
3. If the change is uncommitted and the session is ending, propose a commit:
   `cap commit`.