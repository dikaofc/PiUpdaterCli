---
name: incident-postmortem
description: Write effective blameless postmortems — timeline, root cause, impact, corrective actions, follow-through.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Postmortems

## When & who
- Within 48h of any incident (SEV1/2, or anything users noticed). Lead = involved engineer, not management; everyone who touches the flow contributes facts.

## Structure (blameless, factual)
1. **Summary**: 2-3 sentences — what happened, impact, status.
2. **Timeline**: UTC events with times (alert, detection, investigation steps, mitigation, resolution, verification) — from logs/slack, not memory.
3. **Root cause**: the *mechanism* — "service A retried on 500s with no backoff, DB connection pool exhausted, cascading to B and C" (5-whys until you hit an actionable mechanism, not a person).
4. **Impact**: users affected, requests/errors, duration, cost (revenue/credits) — quantified honestly.
5. **Actions**: corrective items — each: title, owner, deadline, type (prevent recurrence / detect sooner / recover faster).
6. **Retro**: what worked (quick detection), what didn't (monitoring gap, runbook missing).

## Quality rules
- **Blameless by construction**: language describes systems ("the retry loop..."), never "someone didn't..."; blame-free review norms — people need to report errors, not fear them.
- No blame ≠ no accountability: actions have owners + dates (that's the accountability).
- Every action maps to a failure link: no vague "improve testing" — "add integration test for OOM path in X".

## Follow-through (where postmortems die)
- Actions tracked in the issue system (epic per postmortem); weekly check until closed; each action references the postmortem id.
- Review cadence: monthly postmortem retro — pattern across incidents (repeated root cause class = systemic fix).

## Template (minimal)
```
# Postmortem: <title>
- Date, severity, owners
## Timeline
## Root cause (mechanism)
## Impact
## Actions (owner, deadline)
## What worked / what didn't
```

## Checklist
- [ ] Within 48h; factual timeline from logs
- [ ] Mechanism-level root cause
- [ ] Impact quantified
- [ ] Actions with owner+deadline tracked to closure
- [ ] Blameless language throughout