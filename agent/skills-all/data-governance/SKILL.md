---
name: data-governance
description: Data governance for apps — PII mapping, retention, GDPR/CCPA flows (erasure, export, consent), access control on data.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Data Governance

## Map first
- **PII inventory**: table → fields (email, phone, IP, device ids, geo) → sensitivity tier (public/internal/PII/credentials); classify at schema creation (comment + register).
- Retention policy per class: PII records 90d-2y by law/product; logs ≤ 30d (PII scrubbed at source); backups respect retention (exclusions for PII tables).
- Consent ledger: what was consented (scope, timestamp, channel, version); consent withdrawal → operational stop + erase where possible.

## GDPR/CCPA flows (build these as features)
- **Export**: per-user data export (all PII + activity) — scriptable job, async, secure delivery (signed URL, 30d expiry), 30-day SLA.
- **Erasure**: hard-delete orchestrator — user rows + cascade (logs masked by id-hash, backups excluded legally), FKs handled (anonymize vs delete decision per table), idempotent.
- **Rectification/portability**: edit endpoints + export in machine-readable (JSON/CSV).
- Children: age-gate before collection (DPO consult where thresholds).

## Access control on data
- Read access tiers: engineers dev vs prod (masked views), support (tool with masked fields), external (aggregates only). Implement via: DB roles per tier, masking views (`masked_email`), row-level security for tenant columns (`authorization-rbac` applies to data too).
- Query audit: who queried what (logs for PII tables), high-risk patterns alerted (bulk export, `LIKE '%'` scans).
- Third-party processors list (DPA status) — syncs, analytics, LLM providers (see `llm-app-integration` input policy).

## Incident/breach prep
- Detect: suspicious access patterns (time-of-day, volume), logs retention ≥ 90d for forensics. Respond: containment + notification obligations (72h EU; state laws US) — runbook + template letters ready.

## Compliance automation
- Automated scans: schema PII detector (column-name heuristics + review), retention-job coverage test (every table in a retention policy), erasure test (user deleted → all stores scrubbed — integration test!).

## Checklist
- [ ] PII inventory + retention per class
- [ ] Export + erasure + consent flows built & tested
- [ ] Tiered data access (masked views/RLS)
- [ ] Query audit on PII tables
- [ ] Breach runbook + notification templates