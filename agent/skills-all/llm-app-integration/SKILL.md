---
name: llm-app-integration
description: Integrate LLM APIs into apps — prompt design, streaming, structured output, retries, cost/rate budgets, evals, safety.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# LLM App Integration

## Design before tokens
- Model choice: cheapest adequate (task-tuned) vs flagship — classify: extraction/summary/codegen/creative. Context: API keys never in client code (`secret-management`).
- Input policy: what user data reaches the model (PII, IP) — define + log the consent; redact before send.
- Reliability: LLMs are stochastic — the app must treat output as *untrusted data* (validate/schema-parse).

## Prompt & output control
- Structured output: JSON schema enforcement (provider-native `response_format`/structured outputs, or zod parse + retry on parse-fail) — never regex-parse prose.
- Prompt: system (role/format/rules) + user; few-shot for format; keep tokens in budget (tokens = cost + latency).
- Temperature: 0 for extraction/classification; higher for creative; cap `max_tokens`.

## Streaming & UX
- SSE stream tokens (`stream: true`), stop-stream on user cancel, show partial + latency band; failures: fallback message ("please retry") not hang.
- Rate limiting per user (quota) + provider quota monitoring; queue long generations (`background-jobs`).

## Cost & retries
- Track tokens/requests per feature (metering rows); budget alerts; caching identical prompts (exact-match cache) for repeat calls.
- Retries: only on 429/5xx with backoff+jitter; never on 400 (prompt bug — fix, don't retry); idempotency for generation (include deterministic seed/id).

## Eval (the missing layer)
- Golden set (10-100 task samples) + automatic grader (exact match, rubric, or judge-LLM) run in CI on prompt changes; regression = prompt change rolled back.
- Log inputs/outputs (sampled) for incident analysis; human feedback loop (thumbs) feeds evals.

## Safety & guardrails
- System-prompt injection defense: separate untrusted content from instructions (delimiters + instruction adherence test); output filtering (PII scanner, forbidden content) for user-facing generation; tool-use/agent loops: allowlist tools, no arbitrary shell from model output.

## Checklist
- [ ] Structured output parsed+validated, not regexed
- [ ] Streaming + cancel + fallback UX
- [ ] Token/rate budgets + caching; 429/5xx retry policy
- [ ] Evals in CI on prompt changes
- [ ] Untrusted-content separation; no model-driven shell