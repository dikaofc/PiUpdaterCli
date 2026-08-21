# Source: CISA KEV

**Priority: #4** for known in-the-wild exploitation status.

## When to use

- Prioritization: which CVEs are known to be exploited in the wild.
- Operational response: BOD 22-01 requires patching KEV-listed CVEs within
  the due date for federal agencies; use as a forcing function for private
  sector too.

## What to extract

Per catalog entry: `cveID`, `vendorProject`, `product`,
`vulnerabilityName`, `dateAdded`, `shortDescription`, `requiredAction`,
`dueDate`, `knownRansomwareCampaignUse`.

## How to use

- KEV membership is a **priority input**, never an applicability verdict
  (`cve-known-exploitation-priority`).
- Track changes: new entries, removals, due-date changes; re-triage affected
  records (`cve-kev-correlation`, `cve-timeline-analysis`).
- Filter mismatches before elevating priority: product/version/platform must
  match the project component (`cve-kev-false-positive-filter`).

## Traps

- KEV entries generally lack version ranges — absence of a version is not a
  match, it is `UNKNOWN`.
- "Exploited in the wild" describes the CVE, not your project's reachability.
  A KEV CVE that is `PRESENT_BUT_UNUSED` in your project is still LOW risk,
  but gets re-reviewed because exploitation interest raises future-activation
  likelihood.
- KEV is not exhaustive: NOT-listed ≠ not exploited.

## Related

`cisa-kev-ingestion`, `cve-kev-correlation`, `cve-exploitation-status-analysis`,
`cve-known-exploitation-priority`, `cve-kev-false-positive-filter`.
