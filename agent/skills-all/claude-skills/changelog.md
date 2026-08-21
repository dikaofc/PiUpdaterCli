---
name: changelog
description: Maintain a user-facing changelog driven by conventional commits and release tags.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: documentation
  tags: [changelog, release, docs]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Changelog & Release Notes

## Objective
Produce accurate, scannable release notes tied to versions and SemVer.

## Preconditions
- `cap diff` against last tag available.
- Commit convention reviewed (`cap explore <commitlint|contributing>`).

## Workflow
1. Run `cap diff --base <last-tag>` and group changes by type (feat/fix/breaking).
2. Map groups to SemVer (see semantic-versioning) and write human summaries.
3. Link each entry to its PR/issue where possible.
4. Note migration steps for breaking changes prominently.
5. Keep `Unreleased` section fed from commits between releases.
6. Record the changelog process with `cap memory add`.

## Verification
- [ ] Every released change appears.
- [ ] Breaking changes flagged with migration.
- [ ] Entries link to PR/issue.
- [ ] Version matches SemVer.

## Failure Handling
- If a commit is untyped, infer from diff and note it.
- If notes too long, keep summaries, link detail.

## Output Format
Changelog: grouped entries, version, breaking-change migrations, and PR links.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
