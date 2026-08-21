---
name: frontend-debugging
description: Systematic frontend debugging — reproduce, isolate, instrument, bisect, fix, verify. Use when a UI bug resists intuition.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Frontend Debugging

## Method
1. **Reproduce exactly**: input, state, browser, viewport, network conditions. If intermittent — capture repro steps or video first; a bug you can't reproduce you can't verify fixed.
2. **Read, don't assume**: open the code path claimed by the stack trace; check the actual values (console/breakpoints), not the intended ones.
3. **Isolate**: binary search the cause — comment out halves of the handler/component; toggle data (is it the data or the code?); `git bisect` the regression.
4. **Instrument**: `console.log` with labels at entry/exit, or debugger with watch — then remove. Check network tab for the request, state devtools for the value.
5. **Fix smallest**: the causal line, not the symptom layer. Prefer fixing data-shape at source over patching consumers.
6. **Verify**: repro steps pass; adjacent flows still work (same component's loading/empty states); no new console errors.

## Fast checks (in order)
- Console errors/warnings first (unhandled promise, undefined property).
- Network: request fired? status? response shape matches code expectations?
- Devtools: element computed styles for "why is this hidden/invisible".
- React DevTools: props/state at the failing component; which render is wrong.
- Check for stale build (cache, HMR hiccup) — hard refresh before deep diving.

## Common root causes
- Uninitialized state vs undefined; stale closure (StrictMode double-invocation); effects ordering; index keys; timezone/locale formatting; CSS specificity vs JS classes with same names; events not bubbling (stopPropagation).

## Discipline
- One hypothesis at a time; change one variable per run.
- Document the fix in code (comment why), not just this session — the next dev will re-encounter it.

## Checklist
- [ ] Reproduced with exact steps
- [ ] Root cause in code, not a workaround at symptom
- [ ] Verified with original repro + edge case (empty, error, rapid clicks)
- [ ] Instrumentation removed