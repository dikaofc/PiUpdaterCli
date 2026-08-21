---
name: cloud-deployments
description: Deploy to cloud platforms correctly — serverless vs containers, IaC, environment promotion, cost controls.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Cloud Deployments

## Platform choice by workload
- **Serverless (Lambda/Cloud Functions/Vercel/Netlify/Firebase)**: event-driven, bursty API workloads; cold starts cost — long-running/stateful → containers instead.
- **Containers (ECS/Fly/Render/Railway/Cloud Run)**: most backends; manage (or vendor) scaling, healthchecks, rolling deploys.
- **IaaS (EC2/GCE/VPS)**: legacy or special (GPU, custom networking) — same cost planning, more toil.
- Choice criteria: traffic shape, stateful?, latency budget, team ops skills — not prevalence.

## IaC (treat infra as code)
- Terraform/OpenTofu/Pulumi (or CDK): everything provisioned — VPC, DB, buckets, DNS; state remote-locked (S3/GCS backend + dynamo/consul lock); modules for reusable units.
- Version control + CI plan/apply diff review; **no click-ops drift** — `terraform plan` in pipeline, destructive diffs flagged.
- Environments: `dev/staging/prod` as workspaces or env-dirs with same module, different vars; promote from prod-tested artifact (not rebuild).

## Env promotion & config
- Same image across envs; env-specific secrets from secret manager (SSM/AWS Secrets/GCP Secret Manager) referenced by name.
- DNS/SSL: managed certs, `acme.sh` fallback; route via CDN (CloudFront/Fastly) for caching layers (`caching-strategies`).

## Cost governance
- Budgets + alerts per env (e.g. 200% overshoot alert); serverless: idle-time quota kills, `expires` on scratch stacks.
- Right-size: instance type vs utilization graphs monthly; spot/preemptible for batch; object-store lifecycle to glacier after 30d.
- Tag everything (env, owner, app) — cost analytics dicey without.

## Rollout & rollback
- Blue/green or canary via LB target groups; provide healthcheck gates; automated rollback on alarm.
- Regions: single-region default; multi only when SLO demands (cross-region replication designed).

## Checklist
- [ ] IaC applies cleanly with remote state
- [ ] Serverless vs container decision documented
- [ ] Secrets by name from manager, never in code
- [ ] Budgets + tags + rotation enforced
- [ ] Canary/rollback rehearsed