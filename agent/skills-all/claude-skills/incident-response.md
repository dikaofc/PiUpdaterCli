---
name: incident-response
description: Run a production incident — detect, triage, mitigate, and communicate.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: debugging
  tags: [incident, oncall, debugging]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Incident Response

## Objective
Restore service fast while capturing the evidence needed to root-cause.

## Preconditions
- `cap status`/dashboards reachable; on-call and comms channels known.
- Runbooks reviewed (`cap explore <runbook|ops|incident>`).

## Workflow
1. Run `cap status` and check alerts/error rate to confirm and scope the incident.
2. Mitigate first (rollback, scale, feature-flag off) before deep diagnosis.
3. Capture evidence: logs, traces, recent deploys (`cap diff --base <prev>`).
4. Assign roles (IC, comms) and post status updates on a fixed cadence.
5. Once stable, keep the incident open for root-cause (see postmortem).
6. Record the timeline with `cap memory add`.

## Verification
- [ ] Service mitigated and stable.
- [ ] Evidence preserved (logs/deploys).
- [ ] Stakeholders updated.
- [ ] Handoff to postmortem scheduled.

## Failure Handling
- If mitigation uncertain, prefer rollback (safe, reversible).
- If scope grows, escalate early.

## Output Format
Incident summary: impact, mitigation, evidence, comms log, and the postmortem link.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
