---
name: javascript-core
description: Correct vanilla JS patterns — async, closures, prototypes, DOM, modules, errors. Use for any plain JavaScript work or review.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# JavaScript Core

## Language
- `const`/`let`, never `var`. Arrow functions except where `this` binding needed (methods, constructors).
- Strict equality; `Object.is` for NaN/±0. Optional chaining `?.` and nullish `??` (not `||` for defaults — it swallows 0/'').
- Destructuring with defaults; rest/spread over `apply`/`concat`.
- `Map`/`Set` over plain objects for dynamic keys; preserve insertion order.
- Template literals over concatenation; `Intl` for dates/numbers/lists (`Intl.DateTimeFormat`) — never hand-format.

## Async
- Promises or `async/await`; avoid the callback pyramid. `Promise.all` for parallel, `allSettled` when one failure shouldn't kill the batch.
- `AbortController` for cancellable fetch/timeouts.
- Never `await` in hot loops serially when parallelizable.
- Event listeners: remove on teardown (leak prevention).
- Timers: clear on cleanup; `requestAnimationFrame` for rendering, not `setTimeout(16)`.

## Mistakes to catch
- `==` coercion; missing `break`; shadowing; `this` in callbacks (`=>` or capture).
- Mutating inputs passed to other code; shared mutable module state.
- Forgotten error handling in async (unhandled rejections → crash/hang).
- Numeric precision (`0.1+0.2`); use integer cents or `BigInt`.

## Review checklist
- [ ] No `var`, `==`, string concat for interpolation
- [ ] Every async path has try/catch or .catch
- [ ] Listeners/timers cleaned up
- [ ] No mutation of caller-owned objects
- [ ] Errors carry messages that explain to a human