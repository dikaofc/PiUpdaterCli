---
name: super-fast
description: Ultra-lightweight operating mode — minimum tokens, maximum throughput. Batch independent shell commands into one call, strip narration, skip redundant re-reads. Load for bulk edits, multi-file sweeps, or any heavy task on a slow/limited connection.
---

# Super Fast Mode

Default operating mode for heavy work. Trade verbosity for speed.

## Rules

- **Batch reads.** Read 3-5 files in one tool call, not one-by-one. Use `aggregate` for 3+ independent shell queries.
- **No narration.** Zero filler sentences. State the action, the reason, the next step — one line, then the command.
- **No re-reads.** Read each file once. Trust the read. If a later context seems stale, say which line looks wrong instead of re-reading the whole file.
- **Multi-file edits in one pass.** Collect all `edit`/`write` calls for the round and send them together.
- **Short output.** Truncate command output before returning it; the tail usually has the answer. `| tail -20`.

## When done

- Report: files touched, tests run, open question — 3 lines max.
- Skip changelog/essays. If a decision matters, one line of WHY.

## Overrides

- Revert to normal mode automatically when: the task involves security, destructive/irreversible actions, or multi-step sequences where fragment-ambiguity could cause a misread. Write those in plain prose.