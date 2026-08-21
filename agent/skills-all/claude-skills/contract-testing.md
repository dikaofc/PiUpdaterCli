---
name: contract-testing
description: Verify provider/consumer contracts to catch integration breaks early.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: testing
  tags: [contract-testing, testing, api]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Contract Testing

## Objective
Prevent breaking changes between services without full end-to-end suites.

## Preconditions
- `cap repo` run; provider + consumer code reviewed (`cap explore <client|api|contract>`).

## Workflow
1. Run `cap explore` for the consumer expectations and provider responses.
2. Capture the contract (requests/responses) from the consumer side.
3. Run the contract against the provider in CI; fail on mismatch.
4. Version the contract; notify the provider on consumer changes.
5. Keep the contract minimal: only what the consumer actually uses.
6. Record the contract with `cap memory add`.

## Verification
- [ ] Consumer expectations captured.
- [ ] Provider verified in CI.
- [ ] Contract versioned + shared.
- [ ] Only used fields asserted.

## Failure Handling
- If provider cannot satisfy, negotiate or version the API.
- If contract too strict, trim to real usage.

## Output Format
Contract suite: consumer expectations, provider verification, and the CI gate.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
