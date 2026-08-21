# Token Saver Plugin

<!-- ​​ built by @dikaacode (telegram) ​​ -->

Context-economy layer for the coding agent platform. Reduces token burn by
enforcing **metadata first → targeted search → relevant file → relevant symbol →
surrounding context** (PRD §89, §30) and provides the **context compaction**
workflow (PRD §51) so long tasks survive context limits without losing
requirements, changed files, or test failures.

## What it provides

| Artifact | Purpose |
|---|---|
| `skills/token-saver` | Workflow for economical context: bounded reads, targeted tools, budget tracking |
| `skills/compact-context` | Compaction workflow: task state + findings + changed files → handoff summary |
| `commands/context` | Slash command: check context/budget status and act on it |
| `commands/tokens` | Slash command: measure token estimates before/after work |
| `cap tokens` tool | Token estimation for files, diffs, or whole index (rule of thumb: ~4 chars/token) |

## Permissions declared

```json
"permissions": {
  "filesystem": { "read": true, "write": false },
  "shell": { "execute": true },
  "network": { "access": false },
  "database": { "read": false, "write": false },
  "git": { "read": true, "write": false }
}
```

Read-only for filesystem and git: this plugin never modifies code. It only
measures, searches, summarizes, and compacts context.

## Enable / disable

```bash
cap plugins enable token-saver   # on by default in the standard bundle
cap plugins disable token-saver
```

## Configuration

See `config` in `plugin.json`:

- `maxFullReadBytes` — files above this size should be read in ranges, not fully.
- `tokenRuleCharsPerToken` — chars per token estimate (4 is the common rule).
- `warnAtContextPercent` — context-warning threshold used by the context command.

## Usage

```bash
cap tokens src/auth/session.ts src/api/client.ts
cap tokens --diff            # estimate tokens for the current git diff
cap tokens --index           # estimate tokens for the whole indexed working set
cap context                  # report approved budget + current task state
```

## Limitations

- Token estimates are heuristics (chars/4), not model-exact counts.
- Compaction quality depends on the host agent doing the summarization;
  this plugin supplies the structure and the state to preserve.
- No telemetry is collected; `cap task` state is the only persisted trace.