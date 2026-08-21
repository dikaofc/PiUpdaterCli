---
name: debugging-discipline
description: Systematic debugging — reproduce, isolate, hypothesis, verify; log-driven investigation.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Debugging Discipline

## The method (skip no step)
1. **Reproduce** — exact input + environment; if it's flaky, capture steps/video before touching anything (a bug you can't reproduce, you can't verify fixed).
2. **Read, don't assume** — the error message says what it says; check actual values at the point of failure (log/breakpoint), not your mental model of them.
3. **Isolate** — binary search the causal factor: comment halves, toggle data (data vs code), `git bisect` when it worked before.
4. **Hypothesis** — one at a time, each testable ("if X, then Y observable"); change one variable per run.
5. **Fix at the root** — the causal layer, not the symptom (fix the data-shape at source, not the consumer patch).
6. **Verify** — original repro passes; adjacent flows still work; no new console/error-log noise.

## Evidence discipline
- Logs beat intuition: add labeled logs at entry/exit (values, timestamps), reproduce, read, remove.
- Check the obvious first: env/config mismatch (prod vs dev), stale build/cache, permissions, timezone, uninitialized state.
- Stack trace: read bottom-up for the *your-code* frame — library frames are context, not cause.

## Common root causes (checklist-able)
- Async: race (two awaits), unhandled rejection, stale closure, missing await.
- State: uninitialized vs undefined; mutation vs copy; shared mutable across requests.
- Data: encoding/timezone/null-vs-empty; schema drift (cached type mismatch).
- Infra: wrong port/host in config, expired token, DB locks, quota.

## Time discipline
- 20 min rule: stuck without progress → get a second pair of eyes (or fresh perspective on the repro), because depth-perseverance on the wrong path compounds.
- Revert fast: if a recent change correlates with the breakage, revert first, investigate after.

## Checklist
- [ ] Reproduced with exact steps (or flaky-captured)
- [ ] Values verified at failure point, not assumed
- [ ] Single hypothesis tested per run
- [ ] Root-cause fix, not symptom patch
- [ ] Repro + adjacent flows verified after