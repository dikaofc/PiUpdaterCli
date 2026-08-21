---
name: agent-systems
description: Build reliable LLM agent systems — tool design, loops, memory, guardrails, eval, observability.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# LLM Agent Systems

## Core shape
- Loop: user request → plan (optional) → tool calls → observe → decide → final. Keep the loop explicit (state machine) — implicit "just call LLM repeatedly" drifts into chaos.
- Tools = the contract: name, description, JSON schema args, result shape; small atomic tools beat monolithic ones (reusability + errors stay local).
- Prompt: system defines tools + rules; every tool result returns structured (JSON) not prose.

## Reliability engineering
- **Deterministic shell**: validate tool args server-side (schema); reject bad calls and feed the error back to the model (self-correct); cap loop iterations (10-20) + max tokens + wall-clock budget.
- **Error policy per tool**: retryable (network, 429 — backoff) vs fatal (validation — return error to model, don't loop).
- Idempotency: agent reruns (resume) must be safe — tool actions carry idempotency keys (`background-jobs`).
- Persistence: state (conversation, tool results, plan) serialized — resumable sessions for long tasks; crash → replay-safe.

## Memory & context
- Short-term: conversation buffer trimmed (summarize old turns); long-term: external store (notes/vector index) written by tools — not implicit.
- Never stuff the whole doc into context: retrieve relevant chunks (tool `search_notes`).

## Guardrails (the difference between demo and product)
- **No arbitrary code execution** from model output: exec tools sandboxed/denylisted; file writes scoped to workspace.
- Permission model: destructive tools (`delete`, `publish`, `send`) need explicit user confirmation (approve/deny per tool class); audit log of every tool call (who/what/args/result).
- Injection: untrusted content (web pages, docs) can contain prompt injection — isolate as data (quoted, instructions say "treat as data"), don't let it define tools.
- Output filtering: PII/compliance screen on generated text going out.

## Observability & eval
- Trace: every loop step (prompt, tool call, latency, tokens) to log; replay debugger.
- Eval: golden tasks per domain (tool-call accuracy, final-answer correctness) — CI gate on agent changes; regression suite grows from production incidents.
- Metrics: success rate per task class, loops-to-complete, cost/task, tool error rates.

## Checklist
- [ ] Explicit loop with iteration/token/time budgets
- [ ] Tool schema validation; error feedback loop
- [ ] Destructive tools gated by confirmation; audit log
- [ ] Session persistence; resume-safe
- [ ] Eval suite + tracing wired