---
name: state-management
description: Choose and structure client state — server vs UI state, stores, and selectors.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [state, frontend]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Client State Management

## Objective
Keep front-end state predictable and minimal by separating concerns.

## Preconditions
- `cap repo` run; current state approach reviewed (`cap explore <store|state|context>`).

## Workflow
1. Run `cap explore` for where state lives and how it is updated.
2. Split server cache state (from queries) from ephemeral UI state.
3. Pick the lightest fit: local state < context < store; avoid a store for everything.
4. Make updates immutable and derived state computed via selectors, not duplicated.
5. Keep async state (loading/error/data) explicit and cancellable (see async-patterns).
6. Record the state model with `cap memory add`.

## Verification
- [ ] Server vs UI state separated.
- [ ] Lightest viable mechanism used.
- [ ] Derived state via selectors.
- [ ] Async state explicit + cancellable.

## Failure Handling
- If store thrashes, colocate state with its owner.
- If over-fetched, use query cache.

## Output Format
State design: split, mechanism per slice, and async-state handling.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
