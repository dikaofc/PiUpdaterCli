---
name: time-estimation
description: Estimate engineering work realistically — breakdown, uncertainty, historical calibration, communication.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Time Estimation

## Method (bottom-up, calibrated)
1. **Break down** the task to 2-8h units (decompose until each is understood; unknown subparts stay a separate estimate with range).
2. **Estimate each** in effort (focused hours), not elapsed days — then convert: 4-5 focused hrs/day real capacity (meetings, context switches, breaks eat 40-50%).
3. **Uncertainty bands**: single numbers lie — give ranges: optimistic (no surprises), nominal (likely), pessimistic (integration, edge cases, review rounds). Base on *your history*, not hope.
4. **Add buffer**: 20-30% for integration/testing/review — this is not padding, it's the honest cost of reality (reviews, CI, deploy).

## What blows estimates (calibrate for these)
- Integration with unowned systems (third-party APIs, legacy modules) — double the unit.
- Data migration/backfill — multiply by 2: schema + backfill + verification each count.
- Security/access/audit requirements (usually 20-30% extra on any user-data feature).
- Review cycles: PR turnaround, spec changes — schedule as explicit slots.
- The "last 10%" (edge cases, polish, docs, deployment) — always included, never free.

## Communication
- Deliver ranges + assumptions ("2-4d assuming API contract stands; +2d if it changes") — manager gets decision info, you keep slack honest.
- Update early: estimate is a forecast, not a promise — revise as facts change (mid-task discovery counts as new info).
- If > 3 days: split into deliverables with checkpoints (weekly visible progress beats one deadline).

## Anti-patterns
- Estimating to please ("it'll take 1 day" knowing 3) — breaks trust forever.
- Anchoring to the deadline instead of the work.
- Estimating without reading the actual code/spec first (10 min reading = 10x accuracy).

## Checklist
- [ ] Breakdown to 2-8h units with assumptions listed
- [ ] Range (opt/nom/pess) based on personal history
- [ ] Buffer 20-30% for integration/review
- [ ] Decomposed > 3d into milestones
- [ ] Assumptions communicated; forecast revised on new facts