---
name: api-docs
description: Generate accurate API docs from code/schema so they never drift.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: documentation
  tags: [docs, api, openapi]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Documentation

## Objective
Produce living API reference and guides derived from the source of truth.

## Preconditions
- `cap repo` run; API definitions reviewed (`cap explore <openapi|route|schema>`).

## Workflow
1. Run `cap explore` for the API surface and any existing OpenAPI/schema.
2. Derive docs from code (annotations/OpenAPI) rather than hand-writing endpoints.
3. Add request/response examples and auth notes per operation.
4. Wire a docs build into CI; fail on missing descriptions for public operations.
5. Cross-link guides (getting started, errors, pagination) from the reference.
6. Record the doc source with `cap memory add`.

## Verification
- [ ] Docs generated from code, not duplicated by hand.
- [ ] Examples + auth per operation.
- [ ] CI fails on undocumented ops.
- [ ] Guides linked.

## Failure Handling
- If code lacks annotations, add them rather than editing generated output.
- If schema private, document a public subset only.

## Output Format
Docs pipeline: source, generator, CI check, and the published reference link.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
