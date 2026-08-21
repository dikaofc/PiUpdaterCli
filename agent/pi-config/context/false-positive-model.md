# False-Positive Model

A false positive is a reported finding that, after investigation, is disproved or fully
explained away. The purpose of this model is to make false-positive control a **first-class
step** of every investigation: **before reporting a vulnerability, attempt to disprove it.**

## The Disprove-First Discipline

Every candidate finding must pass through the following questions. If any answer
invalidates the finding, classify it as FALSE POSITIVE and record why.

1. **Is the input actually attacker-controlled?**
   If the data comes from a trusted, fixed source (constants, generated values, trusted
   internal callers), the finding is likely a false positive.
2. **Is the code path reachable?**
   Dead code, disabled features, unreachable branches, and never-invoked handlers cannot
   carry a finding (record as INFORMATIONAL at most).
3. **Is authentication required, and is that acceptable?**
   An authenticated-only sink may still be a finding (privilege issue) — but an
   "unauthenticated attacker" claim is a false positive if auth is required.
4. **Is authorization enforced elsewhere?**
   Check every layer: middleware, framework filters, route guards, gateway, service
   layer. A missing check in one function may be compensated upstream.
5. **Is there sanitization or validation?**
   Verify downstream: allow-lists, encoders, parameterized queries, typed accessors,
   validation libraries. The dangerous pattern may be neutralized before the sink.
6. **Is there encoding at the output boundary?**
   XSS/HTML/injection claims require checking the renderer/encoder actually used.
7. **Is the dangerous operation actually executed?**
   A sink in a branch that never runs, a mocked call, a disabled executor, a feature
   flag off by default.
8. **Is the vulnerable dependency actually used, included, and reachable?**
   Follow `dependency-model.md`: installed? bundled? imported? executed? reachable from
   attacker input? Is the vulnerable code path exercised at all?
9. **Does configuration disable the vulnerable path?**
   Framework defaults, deployment config, network policy, WAF rules, CSP, permissions.
10. **Is the behavior intentional and documented?**
    Public endpoints, documented limitations, deliberate trade-offs. Intentionality must
    be evidenced (docs, comments, design notes), not assumed.
11. **Is there a compensating control?**
    A control elsewhere (separate service, gateway, network policy, monitoring+response,
    least-privilege OS) that fully mitigates the impact.

## Invalidation vs. Downgrade

- If the **core claim** (the bad behavior happens) is disproved → **FALSE POSITIVE**.
- If the behavior is real but the **severity was overstated** (reachability, privilege,
  or interaction reduces impact) → keep the finding, **downgrade severity**.
- If the behavior is real but **evidence is weak** → keep the finding, **downgrade
  confidence**, and list the exact test that would raise it.

## What Counts as a False Positive

- scanner/keyword hit without validated code path
- pattern similarity (e.g., string concatenation that is actually a safe template API)
- outdated dependency with no reachable, exploitable path
- "unusual" configuration that is documented and correct
- client-side only control claimed as server-side enforcement
- framework feature mistaken for an application flaw (e.g., framework-generated
  validation error messages treated as an information leak without checking the actual
  deployed response and its sensitivity)

## What Does NOT Count as a False Positive

- "We have never seen it exploited" — lack of observed exploitation is not absence of
  the defect
- "It requires authentication" — that changes severity, not validity
- "It requires user interaction" — that changes severity, not validity
- "It's a lot of work to exploit" — that changes severity, not validity
- "The scanner flagged something similar elsewhere" — evidence is per-path

## Recording a False Positive

Record in the finding tracker or report:

```
Candidate: <title>
Classified: FALSE POSITIVE
Invalidating question: #<N> — <question>
Evidence: <artifact that disproves the claim>
Residual risk: <any remaining low-risk observation, or NONE>
```

## Regression Value

False-positive analysis is not wasted work: it produces the negative controls used in
`regression-testing.md` and prevents alert fatigue that would bury real findings.

## Related

- `../context/evidence-model.md` — E0–E5, the evidence ladder
- `../context/confidence-model.md` — FALSE POSITIVE as a confidence level
- `../context/dependency-model.md` — dependency reachability analysis
- `../skills/reporting/false-positive-analysis.md`
- `../skills/reporting/finding-classification.md`
