---
name: secret-management
description: Manage secrets safely — env vs managers, rotation, access control, scanning, merge-time leaks. Use when reviewing or building credential handling.
category: Security
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Secret Management

## Principles
- Secrets live in a **secret manager** (Vault/AWS Secrets/Cloud KMS/GCP Manager) or injected at runtime — never in code, images, config committed, or env dumps.
- Access via IAM (least-privilege: service→only its secrets; rotate roles on team change).
- Rotation: automated for service creds (cloud keys auto-rotate); humans: 90-180d + on-role-change; DB passwords via operator/secret-manager rotation.

## Runtime injection
- Local dev: `.env`/`.env.local` in `.gitignore` (template `.env.example` committed with keys); docker-compose/env-file; never default secrets in repo.
- Prod: cloud secret manager → container env/file mount → app reads (`config`): `env.ts`-style typed access (`node-backend`).
- Tools: `docker secrets`, k8s `Secret` (+ external `ExternalSecret`/SOPS for GitOps), `dotenv` for local.

## Leak prevention (the fast lane to incident)
- **Scanning in CI blocking**: gitleaks/trufflehog on every commit/PR — blocks secret in diff (gitleaks pre-commit hook + server-side rule).
- Grep hygiene: API keys regardless of format (regex cards: `(sk-|AIza|ghp_|AKIA)`); commit history sweep with `git log -p` + BFG/`filter-repo` — a leaked key is burned, rotate immediately.
- Dual-use risk: `.env` files, `terraform.tfvars`, test fixtures, frontend bundle (client keys are public — never treat as secret).

## Response to a leak (found anywhere)
1. Rotate immediately (kill/token invalidate, type-specific API rotation).
2. Audit access logs of that secret (who could have used it).
3. Purge from git history (filter-repo) + notify affected (password-reset if user cred).
4. Improve prevention (add scanner rule for that pattern) — postmortem in `incident-response` framing.

## Access review
- Quarterly: who has which secret scope; remove stale roles (humans leaving, services decommissioned).
- Encrypt at rest in managers; KMS keys rotated annually.

## Checklist
- [ ] No secrets in repo/config/images/logs
- [ ] CI gitleaks/trufflehog blocking
- [ ] Rotation automated/on-role-change
- [ ] Access least-privilege + quarterly review
- [ ] Leak runbook rehearsed (rotate → purge → notify)