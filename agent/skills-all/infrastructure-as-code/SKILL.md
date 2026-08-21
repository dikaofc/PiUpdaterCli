---
name: infrastructure-as-code
description: Write Terraform/OpenTofu — modules, state, plan hygiene, remote backends, refactors. Use for any IaC work.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Infrastructure as Code (Terraform/OpenTofu)

## Layout (small-to-mid)
```
envs/{dev,prod}/              # backend + main.tf + tfvars
modules/{vpc,db,app,...}/     # reusable units
```
- Modules: input vars with defaults + validation (`validation { condition = ... }`), sensitivity on secrets (`sensitive = true`), outputs minimal.
- Backend: remote (S3+GCS+lock via dynamo/consul/`-lock`); never local `tfstate` in git, never `terraform.tfstate` in repo.

## Plan hygiene
- Every commit: `terraform fmt -check`, `validate`, `plan` with `-detailed-exitcode` used in CI; **review the diff like code** — destroy lines flagged must be intentional + approved (that's the review trigger).
- `-target` only as temporary surgical tool — document, un-target at once (drift accumulates).
- `plan` in CI writes artifact; apply only via pipeline with approval for prod.

## State management
- State = source of truth; drift: `terraform refresh` rarely — find historical `planned_values` vs resource attributes; rejoining imported resources with `terraform import` + matching config shape.
- Lock contention: pipeline lock + `-lock-timeout=120s` in scripts.
- Sensitive: `terraform.tfvars` never committed; values via `TF_VAR_`/env, secret manager references (`data.aws_secretsmanager_secret`).

## Refactor discipline
- add flag `-replace` for forced recreation instead of delete/create mistakes; `moved {}` blocks for renames (no destroy warning).
- Version pinning: `required_providers` + lock files committed; upgrade test on prereleases in staging only.

## Cost/security extras
- `checkov`/`tfsec` in CI (security policy), `infracost` for budget visibility on PRs.
- Resource naming conventions (env prefix) — filtering + compliance.

## Checklist
- [ ] Remote backend + locking; no local state in git
- [ ] fmt/validate/plan in CI; destructive diffs reviewed
- [ ] Modules validated; secrets sensitive + from manager
- [ ] moved {} for renames; -replace over delete/create
- [ ] Checkov/tfsec green