---
name: library-design
description: Design libraries with stable public APIs, sensible defaults, and zero lock-in.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [library, api-design]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Reusable Library Design

## Objective
Ship a library whose surface is intentional, documented, and hard to misuse.

## Preconditions
- `cap repo` run; intended consumers and language conventions known.
- Existing public API reviewed (`cap explore <index|exports>`).

## Workflow
1. Run `cap explore` for the current exports and mark the intended public surface.
2. Keep the public API small; hide internals; version it (see semantic-versioning).
3. Provide sensible defaults but allow override; fail loud on misconfiguration.
4. Avoid leaking implementation types/dependencies into the public signature.
5. Document with runnable examples and add a minimal smoke test.
6. Record the API contract with `cap memory add`.

## Verification
- [ ] Public surface explicit and minimal.
- [ ] Defaults sane; overrides possible.
- [ ] No internal types leaked.
- [ ] Examples run in CI.

## Failure Handling
- If API couples to a framework, extract an adapter.
- If breaking change needed, do a major bump + migration note.

## Output Format
Library design: public surface, defaults, adapters, and example/test coverage.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
