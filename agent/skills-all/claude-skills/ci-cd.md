---
name: ci-cd
description: Design or fix a continuous integration/delivery pipeline with fast feedback and safe deploys.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: devops
  tags: [ci, cd, pipeline, devops]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CI/CD Pipeline

## Objective
Deliver a pipeline that runs verification (lint, test, build) on every change and deploys through guarded stages.

## Preconditions
- `cap repo` run to detect package manager, test, and build commands.
- Access to the CI config files location (`cap explore <ci|workflow|.github|gitlab>`).

## Workflow
1. Run `cap repo` and `cap search` for existing CI definitions (GitHub Actions, GitLab CI, CircleCI).
2. Map the current pipeline stages (`cap show <ci-config> --lines a-b`) and list what is missing: lint, typecheck, test, build, deploy.
3. Keep the test job hermetic: pin versions, cache dependencies, fail fast on the cheapest check first.
4. Add deploy gating: require green checks, use environment approvals, and separate build from deploy.
5. Add a rollback path (previous artifact or `cap rollback`) and a smoke check post-deploy.
6. Record the pipeline shape and gates with `cap memory add`.

## Verification
- [ ] Lint/test/build run on every PR.
- [ ] Cheapest checks run first; pipeline fails fast.
- [ ] Deploy gated behind green checks + approval.
- [ ] Rollback path documented and tested once.

## Failure Handling
- If CI runner unavailable, document the commands so they also run locally.
- If a step is flaky, quarantine it and file a ticket rather than disabling verification.

## Output Format
Pipeline design: stages, order, gating, caches, rollback, and the local-equivalent commands for each CI step.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
