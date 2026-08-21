---
name: postmortem
description: Write a blameless postmortem with timeline, root cause, and action items.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: debugging
  tags: [postmortem, incident, process]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Blameless Postmortem

## Objective
Turn an incident into durable fixes and learning, not blame.

## Preconditions
- Incident mitigated; evidence and timeline available (see incident-response).

## Workflow
1. Run `cap diff`/`cap log` to reconstruct the technical timeline precisely.
2. State impact and user-facing symptoms in plain language.
3. Find the root cause via the "five whys"; separate trigger from systemic cause.
4. List action items with owners and due dates; each prevents recurrence or detects faster.
5. Share widely; feed constraints back into design (see error-handling, observability).
6. Record the postmortem with `cap memory add`.

## Verification
- [ ] Timeline evidence-based (not guess).
- [ ] Root cause separates trigger vs system.
- [ ] Action items owned + dated.
- [ ] No blame language.

## Failure Handling
- If cause unclear, state the gap and add detection, not a guess.
- If actions duplicate past ones, fix the process instead.

## Output Format
Postmortem: impact, timeline, root cause, action items (owner/date), and lessons.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
