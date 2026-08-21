---
name: code-generation
description: Generate boilerplate from schemas/IDLs to cut drift and errors.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [codegen, tooling]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Code Generation

## Objective
Derive code (clients, models, migrations) from a single source of truth.

## Preconditions
- `cap repo` run; the source of truth (schema/OpenAPI/IDL) identified (`cap explore`).

## Workflow
1. Run `cap explore` for the artifact that should be generated and its source.
2. Pick a generator (OpenAPI→client, schema→models, IDL→stubs) and pin its version.
3. Generate into a committed or build-time dir; never hand-edit generated files.
4. Add a check that fails when generated output is stale (`cap verify`).
5. Keep templates under version control; review generated diffs in PRs.
6. Record the generation pipeline with `cap memory add`.

## Verification
- [ ] Single source of truth drives output.
- [ ] Generated files not hand-edited.
- [ ] Staleness check in CI.
- [ ] Templates versioned.

## Failure Handling
- If generator diverges from source, fail the build on drift.
- If output ugly, adjust templates, not output.

## Output Format
Codegen plan: source, generator, output dir, staleness check, and templates.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
