---
name: unit-testing
description: Write good unit tests — naming, isolation, mocks done right, property/table tests, edge cases.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Unit Testing

## Structure
- File-per-module (`auth.test.ts` next to or `__tests__`); group with `describe`/`test` (`test('rejects expired token')`).
- Arrange-Act-Assert with blank-line separation; assert once (or assert on the same outcome), not a zoo of expects.
- **Naming**: "should X when Y" behavior statements, not method names.

## Isolation
- Test only the unit — mock the edges (DB via repository interface/`TestDouble`, network via client stub, time via clock lib).
- Reset state between tests (beforeEach reset DB/registry/global mocks) — leaking state = order-dependent bugs.
- No real network/timers in unit tests (fast, deterministic); those live in integration.

## Mocks & spies
- Mock *collaborators*, not behavior being tested — if a mock asserts implementation detail (called-with), refactor risk rises.
- Prefer dependency injection (constructor/params) over monkey-patching globals; `vi.mock`/`jest.mock` at module level only when necessary (document why).
- Spy on logging only when verifying side effects; assert on the observable result first.

## Table tests / property tests
- Table-driven (input array → expected) for boundary families: empty, null/undefined, min/max, negative, zero, mixed types, Unicode.
- Property tests (`fast-check`) for parsers/reducers: invariants (idempotent sort, round-trip encode/decode).

## Edge coverage (the value)
- Error paths: each `throw`/rejection covered with message assertion.
- Numeric boundaries: float sums, integer overflow, precision (cents); time zones DST shifts.

## Cost rule
- A test that needs a framework-risky workaround (flaky mocking of internals) signals a design smell — simplify the unit instead of hero-mocking it.

## Checklist
- [ ] Behavior-named; one assertion-group per case
- [ ] Isolation via DI; no real I/O
- [ ] Edge/error paths covered (not just happy)
- [ ] Table tests for boundary families
- [ ] Deterministic — no time/order dependence