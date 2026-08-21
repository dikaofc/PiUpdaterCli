---
name: semantic-versioning
description: Apply SemVer correctly — classify changes and bump the right component.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [versioning, semver, release]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Semantic Versioning

## Objective
Assign version numbers that communicate compatibility from the actual diff.

## Preconditions
- `cap diff` available against the last release tag.
- Changelog/release process reviewed (`cap explore <changelog|version>`).

## Workflow
1. Run `cap diff --base <last-tag>` and `cap risk` to classify the change set.
2. Mark breaking API/behavior changes as MAJOR; backward-compatible features as MINOR; fixes as PATCH.
3. Cross-check public surface (exports, routes, schemas) for accidental breaks.
4. Update the changelog (see changelog skill) and tag with the signed version.
5. Bump dependent packages in the monorepo where the API changed.
6. Record the version decision with `cap memory add`.

## Verification
- [ ] Version bump matches the largest change class.
- [ ] No undetected public-surface break.
- [ ] Changelog updated and tagged.
- [ ] Dependents bumped where needed.

## Failure Handling
- If a "fix" silently breaks someone, treat it as MAJOR and add a test.
- If unsure, choose the safer higher bump and document.

## Output Format
Version report: diff class, chosen SemVer component, changed public surface, and tag.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
