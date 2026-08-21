---
name: feature-flags
description: Ship behind flags for safe rollout, kill-switch, and A/B without branches.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [feature-flags, release]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Feature Flags

## Objective
Decouple deploy from release so changes can be toggled per cohort.

## Preconditions
- `cap repo` run; release process and current toggles reviewed (`cap explore <flag|feature|config>`).

## Workflow
1. Run `cap explore` for where the new behavior should be gated.
2. Wrap the change in a flag checked at the edge; default off for risky paths.
3. Store flag state centrally with targeting (user/percent/environment).
4. Add a kill-switch and ensure the off-path is exercised in tests.
5. Plan removal: delete flag + dead branch after the rollout settles.
6. Record flag lifecycle with `cap memory add`.

## Verification
- [ ] Change gated by flag, default off if risky.
- [ ] Targeting + kill-switch present.
- [ ] Off-path tested.
- [ ] Removal plan exists.

## Failure Handling
- If flag lingers, add an expiry/TODO and a cleanup ticket.
- If flag logic leaks, centralize evaluation.

## Output Format
Flag design: flag name, default, targeting, kill-switch, and removal plan.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
