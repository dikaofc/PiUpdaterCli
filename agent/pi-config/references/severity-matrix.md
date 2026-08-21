# Reference: Severity Matrix

Matrix form of `../context/severity-model.md` for quick rating. Score each factor,
then map the total to a level. Use the matrix as a starting point; the narrative
rationale in the report remains mandatory.

## Factor Scoring

| Factor | Low (1) | Medium (2) | High (3) |
|---|---|---|---|
| Impact | minor info/cosmetic | disclosure/modification of limited data | full data breach, code exec, money, outage |
| Exploitability | requires complex sequence/conditions | one authenticated request, no interaction | unauthenticated, trivial trigger |
| Required privileges | admin/internal | any authenticated user | none |
| Required interaction | significant user interaction | minor interaction (click) | none |
| Scope | single user/record | tenant/account | crosses trust boundaries (tenant→tenant, user→admin, app→host, CI→prod) |
| Persistence | one-shot | repeatable | persistent state change |
| Data sensitivity | public/non-sensitive | internal/PII | credentials/payment/health/source |

## Total → Level

| Total (sum of 7 factors) | Severity |
|---|---|
| 18–21 | CRITICAL |
| 14–17 | HIGH |
| 10–13 | MEDIUM |
| 7–9 | LOW |
| ≤ 6 or no demonstrated impact | INFORMATIONAL |

## Calibration Notes

- Any factor scored Low can never produce CRITICAL.
- Cross-boundary scope + no privileges + trivial exploitability + high data
  sensitivity is the CRITICAL combination.
- Availability impact (outage, exhaustion, crash) is scored under Impact at High.
- A finding with E0–E1 evidence cannot be rated above LOW, regardless of the
  matrix result (evidence gate).

## Example

- IDOR reading another user's profile: Impact 2, Exploitability 2, Privileges 2,
  Interaction 1, Scope 3 (tenant→tenant), Persistence 1, Sensitivity 2 → 13 →
  MEDIUM (would be HIGH if sensitivity were credentials).
- Unauthenticated RCE via upload: Impact 3, Exploitability 3, Privileges 3,
  Interaction 1, Scope 3, Persistence 2, Sensitivity 3 → 18 → CRITICAL.

## Related

- `../context/severity-model.md`
- `../skills/reporting/severity-assessment.md`
