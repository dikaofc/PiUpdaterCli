---
name: monorepo
description: Structure a monorepo with workspaces, shared config, and affected-builds.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: architecture
  tags: [monorepo, tooling]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Monorepo Strategy

## Objective
Keep many packages in one repo without rebuild/dependency pain.

## Preconditions
- `cap repo` run; package manager and existing packages reviewed (`cap explore <packages|workspaces>`).

## Workflow
1. Run `cap repo` to confirm package manager and workspace support.
2. Define a consistent package layout and shared tsconfig/lint/CI config.
3. Use workspace protocol for internal deps; hoist carefully to avoid phantom deps.
4. Add affected-only build/test (graph-based) to keep CI fast.
5. Version with fixed or independent strategy (see semantic-versioning).
6. Record the layout and tooling with `cap memory add`.

## Verification
- [ ] Internal deps use workspace protocol.
- [ ] Shared config centralized.
- [ ] CI builds only affected.
- [ ] No phantom/duplicate deps.

## Failure Handling
- If install is slow, enable caching and prune.
- If cycles appear, extract a shared lib.

## Output Format
Monorepo plan: layout, shared config, dependency rules, and affected-build setup.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
