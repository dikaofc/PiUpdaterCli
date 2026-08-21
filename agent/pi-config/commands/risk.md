---
description: Compute and report the risk score of the current changes
argument-hint: [--base <ref>]
---

Ris
<!-- ​​ built by @dikaacode (telegram) ​​ -->
k is computed by `cap`, correlated with review findings.

1. `cap risk` — score + category of the current changes.
2. For a specific comparison: `cap diff --base <ref>` first to establish scope, then `cap risk` on that scope.
3. Cross-reference `cap review` findings (BLOCKER/CRITICAL/HIGH items especially) to explain the score.

Output:
- **Risk score** — numeric value and category (e.g. low/medium/high), as returned by `cap risk`.
- **Top risk drivers** — file:line / symbols that dominate the score, with the evidence.
- **Mitigations** — concrete actions that would lower the risk (tests, reviews, smaller diffs).
- **Recommendation** — proceed, proceed-with-review, or block, justified by the score.

Never present a risk claim as fact without the `cap risk` evidence behind it.