---
name: testing-strategy
description: Plan a test pyramid — unit, integration, e2e — matched to risk and cost.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [testing, strategy, quality]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Testing Strategy

## Objective
Define what to test at each layer so the suite is fast, reliable, and catches real regressions.

## Preconditions
- `cap repo` run; test runner and existing suite mapped (`cap explore <test|spec|__tests__>`).

## Workflow
1. Run `cap test` and `cap explore` to inventory current test types and coverage gaps.
2. Map risk: which modules are most changed and most failure-prone (use `cap diff` history sense).
3. Allocate the bulk to fast unit tests; integration for boundaries (DB, network); e2e for critical user journeys only.
4. Define the contract for each layer: what is mocked, what is real, and the time budget per layer.
5. Add the missing layer tests for the highest-risk module first; keep the suite green.
6. Record the pyramid shape and budget with `cap memory add`.

## Verification
- [ ] Unit > integration > e2e count ordering holds.
- [ ] Each layer has a stated mock boundary.
- [ ] Suite runs in agreed time budget.
- [ ] Highest-risk module now covered.

## Failure Handling
- If tests are flaky, fix determinism before adding more.
- If no time budget, set one and enforce in CI.

## Output Format
Strategy: pyramid counts/budgets, layer contracts (mock boundaries), and the first high-risk module targeted.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
