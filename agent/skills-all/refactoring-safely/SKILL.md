---
name: refactoring-safely
description: Refactor code safely — characterization tests, small steps, mechanical refactors, behavior preservation, rollback.
category: Productivity
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Refactoring Safely

## Preconditions (non-negotiable)
- **Characterization tests first**: untested code → snapshot current behavior with key cases (happy + edge) before touching; refactor that changes behavior without tests = gambling.
- Green baseline: the suite passes before you start (fix unrelated failures first or you can't attribute regressions).
- One concern per change: refactor (behavior same) is a *different PR* from feature (behavior new) — never mix.

## Method (small mechanical steps)
- **Naming/structure first** (rename, extract, move) — compiler-assisted, lowest risk, high value.
- Then logic simplifications: dedupe, remove dead paths, flatten conditionals — each step independently verifiable.
- Every step: run focused tests (module), then full suite; commit after each green step (revert granularity).
- Tools: IDE rename/`extract method`/`jscodeshift`/codemods — mechanical transforms over manual edits (review diff after).

## Behavior preservation checks
- Interfaces: same signatures (or codemod + compiler catches); outputs: same for same inputs (characterization tests assert).
- Side effects: DB writes, logs, external calls — count and order preserved.
- Error paths: same exceptions/types raised; same failure modes (refactor often silently widens try/catch — the classic).

## Size & review
- Land in small PRs (~200-400 lines) with clear messages ("extract X for reuse", "remove dead Y"); review focuses on equivalence.
- Big legacy modules: **strangler** — wrap old with new behind same contract, migrate callers one by one, delete old.

## Rollback
- Every step is reversible: revert the last commit, not the whole branch; if a step's tests fail and you can't fix in 10 min, revert it (don't soldier on — the change was too big).

## Checklist
- [ ] Characterization tests in place (untested code)
- [ ] Suite green before/after each step
- [ ] Mechanical transforms preferred; diffs reviewed
- [ ] Behavior (incl. errors/side effects) preserved
- [ ] Small commits; revertable steps