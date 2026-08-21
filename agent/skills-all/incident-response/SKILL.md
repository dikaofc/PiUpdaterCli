---
name: incident-response
description: Handle incidents systematically — triage, containment, severity, communication, postmortems. Use when something is broken in prod.
category: DevOps
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Incident Response

## Triage (first 2 minutes)
1. Confirm scope: which services/users/regions; `status` page + alert history.
2. Reproduce or capture evidence (logs, traces, metrics snapshot, exact error).
3. Declare severity: **SEV1** (major user impact or data risk) → page on-call, open incident channel; **SEV2** (partial/contained) → same-day fix; **SEV3** (minor) — ticket.
4. Decide: rollback (if recent deploy) > fix-forward > mitigate (degraded mode/rate limit). **Rollback first when a deploy correlates** — speed beats cleverness.

## Containment rules
- Stabilize then fix: stop the bleeding (kill queue drain, feature flag off, scale down consumer) before root-cause exploration.
- Never make things worse: no destructive DB ops during incident without sign-off; no partial deploys mid-incident unless the rollback itself.
- Own communication: single incident commander (decides), scribe (timeline), slack status `[INCIDENT]` pinned; updates on call at 10/30/60 min; stakeholders informed by comms lead.

## Investigation
- Time-correlate: deploy window? config change? traffic spike? `git log` + metric overlay — 80% of incidents trace to a change.
- Work backwards from error signature; check adjacent layers (DB saturation, DNS, quota) before deep-diving app code.
- Preserve evidence BEFORE fixes (logs rotated to retention bucket).

## Resolution & verification
- Fix verified against the original symptom (repro test passes), not "looks fine".
- Post-incident (within 48h): **postmortem** — timeline, root cause (5-whys to the actual mechanism), impact (users/requests/revenue), actions: each `blameless` with owner+deadline; close the loop in an issue tracker.

## Runbooks matter
- Every page alert has a runbook (owner, steps, escalation, rollback cmd) — test them in game days.

## Checklist
- [ ] Severity declared fast; commander + scribe assigned
- [ ] Rollback considered first for recent deploys
- [ ] Evidence preserved pre-fix
- [ ] Fix verified by repro, not faith
- [ ] Postmortem with actions filed