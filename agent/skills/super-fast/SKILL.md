---
name: super-fast
description: Ultra token saver mode — aggressive token budget management, batched operations, compressed output. Load for any task where token cost matters.
---

# Ultra Token Saver Mode (super-fast)

Default operating mode. Minimize tokens while maintaining correctness.

## Rules

- **Batch reads.** Read 3-5 files in one tool call. Use `aggregate` for 3+ independent shell queries.
- **Zero narration.** No filler sentences. Action → reason → command, one line each.
- **No re-reads.** Read each file once. If something looks stale, state which line — don't re-read.
- **Multi-file edits in one pass.** Collect all `edit`/`write` calls per round.
- **Compress output.** Always `| tail -20`. Truncate before returning.
- **Use `compress_context`** tool for any text > 2000 chars before sending to model.
- **Use `web_fetch`** instead of reading large URLs — it auto-retries 429s.

## Token Budget Discipline

- Check `ultra_token_saver` status periodically.
- When compact mode is ON: responses ≤ 3 lines, no markdown formatting, no code fences for single-line output.
- Never repeat information already in context. If asked about something visible, point to it.

## Context Compression

- If context feels heavy, run `compress_context` on long tool outputs.
- Prefer `aggregate` over sequential tool calls — saves 1 round-trip = ~200-500 tokens.
- After completing a task, don't summarize unless asked. The user sees the results.

## When done

- Report: files touched, tests run, open question — 3 lines max.
- Skip changelog/essays. If a decision matters, one line of WHY.

## Overrides

- Revert to normal mode when: security, destructive/irreversible actions, or multi-step sequences where fragment-ambiguity could cause a misread.
- Always use full prose for: auth, secrets, database migrations, anything touching production.
