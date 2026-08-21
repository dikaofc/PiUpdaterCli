# Investigation Principles

The principles every investigation in this knowledge base obeys.

1. **Evidence first.** Findings are built from traceable artifacts, not intuition.
   Evidence levels E0–E5 (`evidence-model.md`) are the currency of every report.
2. **Source code over assumption.** Prefer reading the code, tests, manifests, and
   configuration. If information is missing, mark it `UNKNOWN`.
3. **Trace before you judge.** Do not classify a pattern until you have traced the
   data from source to sink and checked validation and authorization.
4. **Disprove before reporting.** Every candidate finding must survive
   false-positive control (`false-positive-model.md`).
5. **Root cause, not symptom.** The report names the defective implementation and
   the reasoning that produces the behavior, not just the observed symptom.
6. **Minimal reproduction.** Reproduce with the smallest possible controlled test
   (fixture, mock, unit/integration test).
7. **Realistic severity.** Severity follows impact + exploitability + preconditions,
   not the name of the defect class (`severity-model.md`).
8. **Confidence separated from severity.** They are independent axes
   (`confidence-model.md`).
9. **Server-side enforcement.** Client-side checks, hidden UI, and client-provided
   roles/ownership are never treated as security controls.
10. **Remediation with regression tests.** A finding without a proposed fix and a
    regression test is incomplete.
11. **Do not over-report.** Prioritized, small, high-quality sets of findings beat
    speculative bulk output.
12. **Respect boundaries.** Named trust boundaries in every report
    (`../SECURITY_BOUNDARIES.md`).
13. **Preserve behavior.** Fixes preserve existing behavior unless the defect
    requires change.
14. **Honest uncertainty.** `UNKNOWN`, `NOT VERIFIED`, and `PROJECTED` are
    first-class answers.

## Related

- `../METHODOLOGY.md`
- `../context/evidence-model.md`
- `../context/false-positive-model.md`
- `../context/trust-boundaries.md`
