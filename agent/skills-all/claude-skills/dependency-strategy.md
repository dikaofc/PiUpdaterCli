---
name: dependency-strategy
description: Set policy for adding, pinning, and upgrading dependencies without bloat.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [dependencies, supply-chain]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dependency Strategy

## Objective
Keep the dependency graph lean, pinned, and auditable.

## Preconditions
- `cap repo` run; manifest and lockfile reviewed (`cap explore <package.json|lock>`).

## Workflow
1. Run `cap repo` and `cap search` for duplicate/overlapping libraries.
2. Adopt a rule: prefer stdlib/small deps; require justification for new adds.
3. Pin via lockfile; enable integrity hashes; review transitive deps.
4. Schedule upgrades (patch auto, minor reviewed, major planned) with audit gates.
5. Drop unused deps found via tree-shake/dead-code analysis.
6. Record the policy with `cap memory add`.

## Verification
- [ ] No unused deps.
- [ ] Lockfile committed + hashed.
- [ ] New adds justified.
- [ ] Upgrade cadence enforced.

## Failure Handling
- If a dep is abandoned, fork or replace it.
- If upgrade breaks, bisect with the lockfile and pin until fixed.

## Output Format
Dependency policy: add rule, pinning, upgrade cadence, and the unused-dep removal list.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
