---
name: ci-cd-pipelines
description: Design CI/CD pipelines — stages, caching, artifact handling, secrets, merge gates, deploy steps. Use for GitHub Actions/GitLab CI/Jenkins.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# CI/CD Pipelines

## Stages (canonical)
`lint → test → build → artifact → deploy(staging) → smoke → deploy(prod)` — each gate independent; fail fast with clear logs at each.

- **lint/typecheck**: fastest checks first (seconds); PR required.
- **test**: unit → integration (DB/redis via services) → e2e (only on PR or schedule); keep under ~10 min (caching pays).
- **build**: reproducible — lockfiles, pinned base images (`docker-containers`); cache layers (GHA cache / Docker BuildKit / GitLab cache).
- **artifacts**: single immutable artifact per commit (image tag `git-sha`, or tar with sha256) — deploy the exact artifact tested, never rebuild at deploy time.
- **deploy**: staged envs; approvals gate prod; smoke test after (healthcheck + minimal user-path check); rollback plan = re-deploy previous artifact (not code revert).

## Security
- Secrets: CI-native secret store (`secrets`/`variables: protected`) — never in pipeline YAML, repo, or echo; access-scoped tokens (OIDC for cloud) over long-lived keys.
- Never `npm publish`/`docker login` with repo-wide tokens; per-env secrets.
- Signed artifacts (cosign/slsa) when supply-chain matters.
- Dependabot/renovate + `npm audit`/`pip-audit`/`govulncheck` step on schedule; fail on critical (not noisy every vuln).

## Cache & speed
- Cache deps (pnpm/store, go/pkg, pip) keyed by lockfile hash; keep cache small (trim).
- Parallel: matrix for OS/versions, junit reports merged; `concurrency` cancels superseded PR runs (saves resource).

## Merge gates
- PR: lint+unit+build pass, review 1+, no WIP; CI defines "can merge" — never the button alone.
- Branch protection: required checks, force-push off to main, linear history optional.

## Checklist
- [ ] Stages ordered cheap→expensive, cached
- [ ] Immutable artifact per commit; deploy uses it
- [ ] Secrets via native store, no plaintext in yaml/logs
- [ ] Smoke test after deploy; rollback rehearsed
- [ ] Dependabot + vuln scan scheduled