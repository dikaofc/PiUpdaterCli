---
name: session-planning
description: Plan a work session — goal, scope boundaries, checkpoints, timebox, definition of done.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Session Planning

## Before starting (2 minutes)
1. **Goal in one sentence** — outcome, not activity ("deploy v2 billing" not "work on billing").
2. **Scope boundaries**: what's explicitly NOT in (related bugs, refactors, adjacent features) — protects focus.
3. **First action**: the single smallest step to begin (overwhelm = the blocker to kill first).
4. **Checkpoint**: what does "done" look like (tests pass, PR open, metric moved)?

## During
- **Timebox**: schedule units (45-90 min focused blocks) with a stop-and-assess at the end — park, review, extend deliberately (not zombie mode).
- Defer interrupts: collect into a "later" list; only interruptions with urgency > current block jump the queue.
- One task at a time — context switching costs 10-20 min per switch (the real tax).

## Definition of done (make it testable)
- Code: changes work (run it), tests pass, lint clean, PR described, docs touched where behavior changed.
- Research/analysis: decision documented (why), open questions listed, next steps concrete.
- If done can't be stated → the task is too big: split it.

## Handling drift
- Mid-session discovery (better design, hidden requirement): note it, decide consciously — continue scope or escalate; don't silently expand (half-finished everything beats one finished thing + loose ends).
- End of session: summary of what shipped, what's blocked, what's next (handoff-ready state even for solo work — tomorrow-you thanks you).

## Checklist
- [ ] One-sentence goal; boundaries explicit
- [ ] First action identified
- [ ] Timebox + checkpoint set
- [ ] Done is testable
- [ ] Drift decisions made consciously