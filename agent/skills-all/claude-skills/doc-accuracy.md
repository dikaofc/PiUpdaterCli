---
name: doc-accuracy
description: Verify documentation claims against the actual code — contracts, examples, and behavior — and report discrepancies.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [docs, accuracy, verification]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Doc Accuracy Check

## Objective
Verify that documentation (function docs, API docs, guides) matches the code it
describes: signatures, contracts, failure modes, and examples. Every doc claim is
resolved against the implementation via `cap` facts; discrepancies are reported with
the doc quote, the code truth, and evidence, and corrected only if the fix is
unambiguous.

## Preconditions
- Repository is indexed (`cap index --refresh`) so symbols referenced by the docs resolve to real code.
- The documentation files to check are named (README, `docs/*`, API references) via `cap pick`/`cap explore`.

## Workflow
1. Run `cap status` and `cap repo` to confirm the documentation layout and the language of the code.
2. Enumerate doc files: `cap pick --query "docs|README|API" --type md` or `cap explore "docs"`.
3. Extract claims per doc file: read with `cap show <doc-file>`, listing every statement about a symbol, contract, parameter, return, error, or behavior example.
4. Resolve each claim to code: `cap explore <symbol>` finds the definition; `cap show <file> [--lines a-b]` reads it.
5. Compare claim vs implementation and classify:
   - ACCURATE — claim matches code.
   - STALE — doc no longer matches current code.
   - WRONG — never matched (contract, signature, failure mode, example output).
   - UNVERIFIABLE — symbols not found, examples reference removed code.
6. Re-run examples that include commands/output: verify against `cap search` results or by executing safe ones; never run destructive examples.
7. Run `cap risk --json` to scope; an inaccurate API doc on a public function is a high-severity finding even if the code is fine.
8. Fix only unambiguous doc errors (typos, stale signatures, wrong examples where the code is clear) — edit the doc, then re-`cap show` to confirm the claim now matches.
9. Ambiguous discrepancies (doc and code both plausible): report both readings, do not pick one.
10. `cap memory add` recurring accuracy issues found (e.g., "docs auto-generated, verify after public API changes").

## Verification
- [ ] Every doc claim classified; classification has code evidence from `cap show`.
- [ ] All examples that were re-run produce outputs matching the doc, or the discrepancy is reported.
- [ ] Fixed docs pass `cap show` re-check (claim ⇔ code now agree).
- [ ] `cap verify` unaffected (doc-only edits) — confirm via `cap diff`.
- [ ] Unverifiable claims listed separately, never silently dropped.

## Failure Handling
- If a doc claim names a symbol that does not resolve (`cap explore` empty): report as UNVERIFIABLE with the full claim quoted; do not assume it refers to a similar symbol.
- If an example would execute dangerous code: skip execution and mark the claim as VERIFY-MANUALLY rather than risk side effects.
- If doc and code conflict on a contract that affects callers: elevate to BLOCKER-level report; a fix requires a code or doc decision, not a unilateral edit.

## Output Format
- Claims table: doc file | quoted claim | resolution (symbol/file:line) | class (ACCURATE/STALE/WRONG/UNVERIFIABLE) | severity.
- Corrections applied (doc file, old → new text) and confirmation.
- Unverifiable / manual-verify items.
- Verification summary (`cap diff`, `cap risk` if touched code).

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap pick`, `cap explore`, `cap show`, `cap search`, `cap risk`.
- CONTRACT.md §3 Doc-comment rules — public function docs are contract.