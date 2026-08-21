---
name: release-management
description: Cut releases safely — tagging, notes, artifacts, and a rollback plan.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: devops
  tags: [release, devops, cd]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Release Management

## Objective
Ship a release with verified artifacts, clear notes, and a one-command rollback.

## Preconditions
- `cap status` clean; CI green; version decided (`cap risk` acceptable).
- Changelog prepared (see changelog skill).

## Workflow
1. Run `cap verify` and `cap risk`; block release on red or high unaccepted risk.
2. Tag the release (signed) and build immutable artifacts.
3. Publish notes (see changelog) and the version (see semantic-versioning).
4. Deploy via the pipeline (see ci-cd) with the rollback path armed.
5. Run a post-deploy smoke check; monitor error rate for the first minutes.
6. Record the release with `cap memory add`.

## Verification
- [ ] CI green + risk accepted.
- [ ] Tagged + artifacts immutable.
- [ ] Notes published.
- [ ] Rollback armed + smoke passed.

## Failure Handling
- If smoke fails, roll back immediately; investigate before retry.
- If artifact bad, rebuild from the same commit.

## Output Format
Release record: version, tag, artifacts, notes, deploy target, and rollback command.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
