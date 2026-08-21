---
name: documentation-writing
description: Write developer docs that stay true — README, ADRs, API docs, runbooks; verification and freshness.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Documentation Writing

## Principles
- **Docs earn trust by being correct** — every claim verifiable against code; stale docs are worse than none (they teach wrong things confidently).
- Write for the reader's need: onboarding (README), decisions (ADR), operations (runbooks), API (contracts) — each has its own format, don't fuse.
- Short > long: a page that fits one screen gets read; paragraphs of preamble get skipped.

## README
- One-paragraph what+why, quickstart (3-5 commands to running), config table (env vars + defaults), test command, architecture pointer, contribution note. Screenshot/gif for UI projects — the fastest comprehension.

## API docs
- Auto-generate from the contract (OpenAPI → docs) + hand-write the *usage* (examples, error handling, rate limits) — generators emit signatures, not judgment. Every endpoint: example request/response, error table, auth requirement.

## ADRs (Architecture Decision Records)
- Format: Context (forces) → Decision → Consequences (costs, tradeoffs) → Alternatives considered. One decision per ADR, dated, linked to issues; supersedes reference (ADR-N supersedes ADR-M).
- When: any non-obvious architectural choice — record *why*, future readers will question it.

## Runbooks
- Alert → symptoms → steps (exact commands) → rollback → escalation; tested by dry-run (game day); owned + reviewed quarterly (they rot).

## Freshness
- Verify on change: docs referencing code must update in the same PR (CI check: docs diff required for public-API changes).
- Link, don't duplicate (single source: schemas, config defaults, deploy steps live in one place).
- Mark `(outdated?)` items for triage rather than deleting context.

## Checklist
- [ ] Claims verified against code before writing
- [ ] Format matches need (README/ADR/runbook/API)
- [ ] Single source; links not copies
- [ ] Docs updated in same PR as behavior
- [ ] Runbooks tested