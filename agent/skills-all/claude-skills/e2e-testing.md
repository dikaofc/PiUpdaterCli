---
name: e2e-testing
description: Cover critical user journeys with reliable, flake-free E2E tests.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [e2e, testing, quality]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# End-to-End Testing

## Objective
Prove key flows work across the real stack without slowing the suite.

## Preconditions
- `cap repo` run; E2E framework and environments reviewed (`cap explore <e2e|playwright|cypress>`).

## Workflow
1. Run `cap explore` for the highest-value journeys (login, checkout, deploy).
2. Write few, stable flows using resilient selectors (roles, text), not brittle CSS.
3. Make tests independent and idempotent; seed/clean state per run.
4. Add explicit waits on conditions, never fixed sleeps.
5. Run in CI on a real environment; quarantine flakes, never ignore them.
6. Record the journey list with `cap memory add`.

## Verification
- [ ] Only critical journeys covered.
- [ ] Selectors resilient (no brittle CSS).
- [ ] Independent + idempotent.
- [ ] Flakes quarantined, not silenced.

## Failure Handling
- If a flow is non-deterministic, stabilize the app, not the test.
- If too slow, move coverage to lower layers.

## Output Format
E2E suite: journeys, selectors, state strategy, and the CI run result.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
