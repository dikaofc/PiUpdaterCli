# CVE_TRIAGE.md

The priority model and triage rules that turn validated, reachability-aware
findings into an actionable queue.

## Inputs to every triage decision

| Input | Source | Notes |
|---|---|---|
| Severity | validated CVSS (canonical, version-tagged) | from `cve-severity-analysis` |
| Reachability class | reachability engine | 6 standard classes |
| Evidence level | reachability-evidence-model | E0–E5 |
| KEV / exploitation | CISA KEV + status analysis | priority input only |
| Asset criticality | inventory/deployment | from the project |
| Exposure | network-facing / internal | from the project |

## Priority bands

Bands are derived from the inputs; every label is reproducible.

- **CRITICAL** — `DIRECTLY_REACHABLE` (evidence ≥ E4) **and** (KEV listed
  **or** validated severity High/Critical) **and** asset is critical.
  Rationale must be stated; no band is auto-assigned by severity alone.
- **HIGH** — `DIRECTLY_REACHABLE` with evidence ≥ E4 (without the CRITICAL
  conditions), or `CONDITIONALLY_REACHABLE` with a common condition + KEV.
- **MEDIUM** — `CONDITIONALLY_REACHABLE` (named conditions), or
  `PRESENT_BUT_UNUSED` with plausible future activation (documented), or
  `TRANSITIVELY_REACHABLE` without confirmed input influence.
- **LOW** — `PRESENT_BUT_UNUSED` with no plausible activation; or
  `UNREACHABLE` findings kept for hygiene only.
- **REVIEW (UNKNOWN)** — reachability or data `UNKNOWN`. Never merged into
  another band silently; carries a review requirement.

## Rules

1. **KEV raises priority, never exploitability.** A KEV-listed CVE that is
   `PRESENT_BUT_UNUSED` in the project stays LOW/REVIEW but is re-reviewed;
   the report must state the code path is not currently used.
2. **`UNKNOWN` is reviewable, not clean.** Unknown reachability ranks by
   severity with a visible caveat.
3. **Severity ≠ project risk.** CVE severity describes the vulnerability;
   the band derives from severity *plus* local reachability and exposure.
4. **Score decomposability.** Any band decision can be explained by its
   inputs; disputes resolve by checking inputs, not intuition.
5. **Evidence gate.** A band requires the evidence level stated for it.
   Missing evidence auto-downgrades the verdict to `UNKNOWN`/REVIEW.
6. **Remediation ordering** then applies risk × cost (see
   `CVE_REMEDIATION.md`).

## Triage scoring sketch

```
score = w1*severity(normalized bands)
      + w2*reachability_class_weight
      + w3*kev_boost          (0/1, with dates)
      + w4*asset_criticality
      + w5*exposure
if evidence_level < class_requirement: score -> REVIEW
```

Weights are configurable and published; the point is transparency, not the
exact numbers. No numeric score is ever presented as certainty.

## KEV handling

- KEV membership stored with `dateAdded`, `dueDate`, `requiredAction`,
  `knownRansomwareCampaignUse` (`cve-kev-correlation`).
- KEV addition triggers re-triage (`cve-timeline-analysis`).
- KEV entries are checked for product/version/platform mismatch before they
  can move a finding (`cve-kev-false-positive-filter`).

## Confidence

Every triage decision carries a confidence derived from the evidence level
and source quality (`cve-confidence-model`):

- HIGH — direct verified evidence at the required level.
- MEDIUM — strong indirect evidence.
- LOW — inference.
- UNKNOWN — insufficient data (a state, not a value).

## Output

The triage queue (ordered), per-item inputs, band rationale, and decision
records from `cve-triage-review-workflow`. Reports use
`templates/cve-report.md`.
