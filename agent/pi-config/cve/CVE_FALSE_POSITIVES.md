# CVE_FALSE_POSITIVES.md

The false-positive model for the CVE Intelligence Engine. An FP is a
candidate that looked applicable but is not — or whose evidence does not
support the claim. FPs are *recorded, evidence-gated, and reversible*.

## FP classes

| # | Class | Question it answers | Decisive skill |
|---|---|---|---|
| 1 | Duplicate/alias | Same CVE ingested twice or via aliases? | `duplicate-detection`, `record-merging` |
| 2 | Product mismatch | CVE names a different product/vendor? | `cve-cpe-matching`, `vendor-correlation` |
| 3 | Version out-of-range | Installed version outside the affected range? | `cve-version-matching` |
| 4 | Platform/architecture | CVE targets a different OS/browser/ISA? | `cve-platform-matching`, `cve-architecture-matching` |
| 5 | Feature/config/flag | Vulnerable behavior gated off in this deployment? | `cve-configuration-applicability`, `cve-feature-flag-analysis`, `cve-disabled-feature-analysis` |
| 6 | Not deployed | Dev/optional/build-only component never ships? | `cve-optional-component-analysis` |
| 7 | Functionality absent | Vulnerable module/function not in the installed version? | `cve-vulnerable-code-path` |
| 8 | Path not used | Imports/calls do not reach the vulnerable code? | `import-graph-analysis`, `call-graph-analysis` |
| 9 | Mitigation verified | A stated mitigation actually closes the path? | `cve-configuration-applicability` |
| K | KEV mismatch | KEV product/version/platform does not match? | `cve-kev-false-positive-filter` |

## Rules

1. **Evidence per verdict.** Every FP is tied to the filter that fired and
   the evidence. No evidence → the filter does not apply.
2. **`UNKNOWN` is not an FP.** Missing evidence yields `UNKNOWN` (REVIEW
   band), never "clean". The FP engine removes noise; it does not launder
   uncertainty.
3. **Nothing is auto-deleted.** FP verdicts are reviewable, reversible, and
   auditable — they stay in the record with the filter used.
4. **Apply in order.** Filters run 1 → 9 so that later filters see a
   pre-cleaned candidate set; each verdict remains attributable.
5. **Guard against FP-of-the-FP.** The engine's own false *negatives*
   (wrongly filtering a real finding) are monitored: sample re-review and
   accuracy tuning per filter.
6. **Severity/exploit-status FPs.** A wrong vector or a stale KEV flag is an
   FP of data, handled by validation (`cve-vector-conflict-detection`,
   `cve-kev-false-positive-filter`), not by the reachability stack.

## Common FP patterns to watch

- **Range endpoint errors** — inclusive/exclusive confusion makes a version
  look affected when it is fixed (`cve-range-analysis`).
- **Distro backports** — OS packages patched by the distro appear vulnerable
  to upstream version matching (`cve-os-package-analysis`).
- **Wildcard CPEs** — `vendor:*`/`version:*` CPEs make platform verdicts
  unknown, not affected.
- **Description-keyword CWE inference** — inferred weakness claims presented
  as authoritative (`cwe-normalization`).
- **KEV product families broader than the component** — verify the product
  line before elevating priority.

## Output

FP run reports (candidates reduced by filter, verdicts + evidence) feed the
final report and the engine's accuracy review loop
(`cve-false-positive-engine`).
