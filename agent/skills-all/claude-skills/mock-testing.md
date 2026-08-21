---
name: mock-testing
description: Use mocks, stubs, and fakes correctly — verify behavior, not implementation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [mocking, testing, tdd]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Test Doubles & Mocking

## Objective
Isolate units for fast tests without coupling to internals.

## Preconditions
- `cap repo` run; test framework and current doubles reviewed (`cap search <mock|stub|spy>`).

## Workflow
1. Run `cap explore` for the unit boundaries and its collaborators.
2. Prefer real collaborators or fakes over mocks where practical.
3. Mock only slow/non-deterministic boundaries (network, clock, DB).
4. Assert on outcomes/contracts, not on calls to internals.
5. Keep mocks in the test, never in production code.
6. Record the double strategy with `cap memory add`.

## Verification
- [ ] Only true boundaries mocked.
- [ ] Assertions on behavior, not internals.
- [ ] No mocks in prod.
- [ ] Tests fast + deterministic.

## Failure Handling
- If a mock is fragile, the contract changed — update the test, not the mock hack.
- If over-mocked, use a real collaborator.

## Output Format
Test-double plan: what is faked vs real, assertion style, and the speed gain.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
