# Source: Vendor Advisories

**Priority: #1** for affected/fixed versions and product-specific severity.

## When to use

- The vendor published an advisory for the CVE or a related advisory family
  (Apache, Microsoft, Spring, Red Hat, WordPress, Docker, etc.).
- You need the precise affected/fixed version list for the vendor product —
  aggregated feeds frequently lose or mangle this.

## What to extract

- Advisory id, CVE references, published/updated dates.
- Affected versions (often the most accurate statement anywhere).
- Fixed versions, workarounds, mitigation config.
- Links to patches.
- Vendor CVSS if the vendor computed its own (compare with NVD).

## How to use

- Feed vendor-derived affected/fixed versions into the canonical record
  *preferentially* (per-field provenance preserved).
- Keep the original document in `advisories/vendor/<vendor>/` for audit.
- Vendor severity is advisory-level; the canonical severity is selected by
  the validation layer with source-priority, and discrepancies are explained
  at the metric level (`cve-advisory-severity-validation`).

## Traps

- Prose advisories ("all releases prior to ...") need careful version
  interpretation via `version-normalization`.
- Vendor version schemes may differ from upstream (distro rebuilds,
  commercial editions) — apply `cve-os-package-analysis` semantics for
  distro-patched products.
- A vendor may issue an advisory for a product line the project does not
  use — verify product identity (`vendor-correlation`, `cve-cpe-matching`).

## Related

`vendor-advisory-ingestion`, `vendor-correlation`,
`cve-fix-version-resolution`, `cve-advisory-severity-validation`.
