---
name: tdd-practices
description: Practice TDD pragmatically — red/green/refactor, test-first for bugs, when TDD wins, mutation testing.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# TDD (Pragmatic)

## Core loop
1. **Red**: write the failing test describing desired behavior (one assertion family).
2. **Green**: minimal code to pass (no golden platitudes — just enough).
3. **Refactor**: improve under the safety net (rename, dedupe, structure) — tests stay green.

## Where TDD pays
- **Bug fixes**: write a test reproducing the bug → fix → test passes → the regression is locked. The single highest-value TDD use.
- New business rules (pricing, validation, parsers) — behavior spec naturally becomes the test suite.
- Edge-heavy logic (dates, money, strings) — TDD drives out the boundary cases.
- Skip for: UI polish, CSS, one-shot scripts, exploratory spikes (throwaway). Don't cargo-cult red-green-green for trivial getters.

## Discipline
- Write the test for the *behavior*, not the implementation (`unit-testing`): a test that asserts `mockedDb.query` called is testing the mock.
- Small increments: one case → one line of behavior; run test after each step (fast suite makes this pleasant).
- If the code already exists without tests: character-test it (snapshot the current behavior with a few key cases) before refactoring — `characterization` tests document "what it does today", then you can safely change.

## Level up: mutation testing
- Run `stryker`/`mutmut` on a module: kills tests that pass because nothing verifies behavior — survivors = blind spots to cover. Use selectively (slow), on the module with the most business logic.

## Red flags
- TDD producing brittle tests (over-mocked internals) — the design smells; the unit should be simpler.
- All tests green while behavior broken = missing integration/e2e layer (`testing-strategy`).

## Checklist
- [ ] Bug: repro test written first, passes after fix
- [ ] Rules tested edge-first (boundaries, errors)
- [ ] Tests assert outcomes, not mocks
- [ ] Characterization tests before refactor of untested code
- [ ] Mutation spot-check on critical logic