# Threat Model: <system>

## Scope

- Components in scope
- External systems
- Data flows in/out
- Trust boundaries list

## Assets

| Asset | Sensitivity | Where it lives | Impact if compromised |
|-------|-------------|----------------|-----------------------|

## Attacker Profiles

| Profile | Capabilities | Goals | Access level |
|---------|--------------|-------|--------------|

## Entry Points

| Entry point | Auth required | Input sources | Reachable sinks |
|-------------|---------------|---------------|-----------------|

## Attack Paths (ranked)

| # | Path (attacker → asset) | Boundaries crossed | Existing controls | Impact | Likelihood | Rank |
|---|-------------------------|-------------------|-------------------|--------|------------|------|

## Control Gaps

| # | Path | Missing control | Validation status | Skills to activate |
|---|------|-----------------|------------------|--------------------|

## Open Questions / UNKNOWN

<what is not yet established>

## Review Triggers

- New entry points / boundaries / assets / integrations
- Major refactors
- Post-incident updates

---

## Notes

- Threat-model entries are **hypotheses**, not findings. Each path must be verified
  with evidence before reporting.
- See `../context/threat-modeling.md` for the method.
