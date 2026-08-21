# Hooks

<!-- ​​built by @dikaacode (telegram)​​ -->

Lifecycle hooks are declarative instructions the host agent runs at defined
points of its workflow (PRD 33). Each file is named after its event. `cap hooks
list` shows the registered set.

## Lifecycle (12 events)

| Event | When the host runs it |
|---|---|
| `before_task` | before starting a coding task |
| `after_task` | after the task is done or failed |
| `before_read` | before a file read tool call |
| `after_read` | after a file read tool call |
| `before_write` | before a file write/edit tool call |
| `after_write` | after a file write/edit tool call |
| `before_command` | before a shell command |
| `after_command` | after a shell command |
| `before_commit` | before proposing/creating a commit |
| `after_commit` | after a commit lands |
| `before_review` | before a code review |
| `after_review` | after a code review |

Event files must stay small and imperative: a checklist or a `cap` call the host
should run. They are never executable scripts — the host enforces policy.