---
name: api-doc-gen
description: Generate API documentation from the public surface — signatures, contracts, and failure modes.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: documentation
  tags: [api, docs, reference, contract]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# API Doc Generation

## Objective
Generate an API reference document from the real public surface of a module or
service: exported symbols, signatures, parameter and return contracts, and failure
modes — every entry resolved from code via `cap` facts, never from memory. Output is
a structured doc (markdown or per project convention) that a consumer can rely on.

## Preconditions
- Repository is indexed (`cap index --refresh`) so the index can resolve exports and cross-references.
- The target module/service is named or discoverable via `cap explore`.
- The intended doc format/emission point (file path, README section) is agreed.

## Workflow
1. Run `cap status` and `cap repo` to confirm project language and library conventions.
2. Identify the entry: `cap explore "<module>"` or `cap explore "main|index|lib"` to find the module's exports.
3. Enumerate the public surface: `cap search "export"` in the module, then deduplicate with `cap explore <file>`; confirm each export is reachable from the entry point.
4. For each exported symbol, read the definition: `cap show <file> [--lines a-b]` capturing signature, JSDoc/comment contract, parameter and return types, and test coverage hints.
5. Resolve cross-references: `cap explore <source-type>` for types/interfaces/errors referenced by signatures; note sub-symbol contracts.
6. Extract failure modes per symbol: `cap search "throw|reject|error"` near the definition and the documented contract; if the code has no declared errors, test them against `cap show` of tests (`cap test --target <file>` names the error cases).
7. Draft the doc per symbol: **Signature** (verbatim), **Parameters/Return** (typed), **Contract**, **Failure modes**, **Example** (an existing test or a runnable call, verified).
8. Run `cap rules check <file>` on the doc — public function docs must state contract and failure modes.
9. Write/append the doc at the agreed location (or emit to stdout for review); cite file:line for every claim so it is auditable.
10. Verify freshness: re-run `cap index --refresh` + `cap explore <symbol>` spot-checks; a doc generated off the index is only as good as the index. `cap diff` to confirm the new/edited doc and, if the user approves, `cap commit --dry-run`.

## Verification
- [ ] Every exported symbol has an entry; none invented from naming conventions.
- [ ] Signatures pasted verbatim from `cap show` output.
- [ ] Every failure mode claim traced to a `throw`/error test or declared contract.
- [ ] `cap rules check <file>` passes for doc-comment rules.
- [ ] Examples are runnable commands/outputs verified against `cap test` or `cap show`.
- [ ] `cap index --refresh` resolves every referenced symbol (no dead links).

## Failure Handling
- If an export's contract is undocumented in code (no comments, no tests): mark the entry CONTRACT-UNKNOWN and list the open questions — never invent a contract that matches the signature.
- If a symbol cannot be resolved after `cap index --refresh`: drop it from the public surface and note the discrepancy; report to the user as possible dead export.
- If the generated doc would exceed the agreed scope (user asked for one module): stop at the boundary and offer the rest as a follow-up.

## Output Format
- Document structure: Module overview → Exports (each with Signature, Params/Return, Contract, Failure modes, Example, file:line source) → Open questions (CONTRACT-UNKNOWN entries).
- Validation summary: symbols enumerated, resolved, dropped; `cap rules check` result.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §3 Source/API rules (public functions document contract + failure modes).
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap test`, `cap rules check`.