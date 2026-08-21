# Confidence Model

Confidence expresses how sure we are that the described defect exists and behaves as
described. It is a statement about the **finding**, not about its impact.

**Confidence is separate from severity.** They answer different questions:

- Severity: *If this is real, how bad is it?*
- Confidence: *How sure are we that this is real?*

A theoretical SSRF in an unreachable code path can be:

- Severity: HIGH, Confidence: LOW

A minor information leak proven by a failing test can be:

- Severity: LOW, Confidence: CONFIRMED

Never collapse these axes. A "critical" label without confidence is noise; a confirmed
finding with low severity is still worth fixing.

## Levels

### CONFIRMED

The defect exists, the behavior is demonstrated (E3+), and the root cause is validated
(E5). A regression test fails before the fix and passes after it.

Requirements:

- controlled reproduction performed
- impact observed or directly argued from observed behavior
- root cause identified at the code level

### HIGH CONFIDENCE

Strong evidence the defect exists; reproduction may be partial or a narrow detail
remains unverified. Typical basis:

- E2 data-flow trace plus a partial behavioral demonstration (E3) with an unexplained
  edge case
- multiple independent code paths converge on the same defective behavior
- behavior observed (E3) but root cause (E5) not yet isolated

### MEDIUM CONFIDENCE

Evidence points to a real issue but important variables are unverified. Typical basis:

- E2 data-flow evidence without behavioral confirmation
- E1/E2 evidence plus a compensating control that might invalidate it
- behavior observed in an uncontrolled or non-representative environment

### LOW CONFIDENCE

Suspicion only. Typical basis:

- E1 static evidence without a completed trace
- a pattern or keyword that merely resembles a known defect class
- a claim based on a similar project's experience rather than this project's evidence

### FALSE POSITIVE

After investigation, the suspected defect is disproved or explained:

- input is not attacker-controlled
- code path is unreachable
- sanitization/authorization is enforced elsewhere
- configuration disables the vulnerable path
- behavior is intentional and documented
- a compensating control fully mitigates

## Calibration Rules

1. Assign confidence from evidence, not from how the issue makes you feel.
2. Downgrade when any link in the chain (source → trace → sink → behavior) is inferred
   rather than observed.
3. Downgrade when the reproduction environment differs materially from the real one
   (different versions, different configuration, mocked components that change
   semantics).
4. Upgrade only when evidence is reproduced more than once, ideally by an independent
   method.
5. When unsure between two levels, take the lower one and record what evidence would
   raise it.

## Recording

Every finding must state confidence with the evidence level that supports it, e.g.:

```
Confidence: MEDIUM CONFIDENCE
Evidence:   E2 (data-flow trace complete; behavior not yet reproduced)
```

## Related

- `../context/evidence-model.md` — the evidence levels used to justify confidence
- `../context/severity-model.md` — the separate impact axis
- `../context/false-positive-model.md` — how to disprove before reporting
- `../skills/reporting/confidence-assessment.md`
- `../skills/reporting/false-positive-analysis.md`
