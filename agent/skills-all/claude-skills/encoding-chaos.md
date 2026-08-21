---
name: encoding-chaos
description: Debug encoding and Unicode corruption — charset, BOM, normalization, invisible characters — by inspecting byte-level truth, never rendered guesses.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [encoding, unicode, charset, bom]
---

# Encoding Chaos
<!-- built by @dikaacode (telegram) -->

## Objective
Resolve a garbled-text or Unicode bug into its exact byte-level cause — wrong charset decode, missing/injected BOM, NFC vs. NFD normalization, or invisible characters — proven by hex inspection at each boundary, then fixed at the boundary that corrupts and verified with a byte-exact test.

## Preconditions
- The garbled sample is available as a file, response body, or log line, not only as rendered text.
- The pipeline that moves the bytes is identifiable (read → transform → store → render) via `cap repo`.
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; capture the sample's truth as bytes early — `cap show <file>` on the raw payload or a hex dump of the log/response (renderings lie; bytes do not).
2. Locate every boundary that interprets bytes: `cap search <readFile|decode|utf8|latin1|charset|iconv|Buffer|normalize>` — each read/write/parse/render site plus declared charset in headers/config.
3. Classify the corruption class at the failing boundary by its signature, from the hex:
   - Replacement char (`EF BF BD` / `FF FD`): bytes decoded with the wrong charset and re-encoded.
   - BOM injected (`EF BB BF` where unexpected) or stripped when expected: header/stream boundary.
   - Canonical mismatch: same glyphs, different code points (NFC `C3 A9` vs. NFD `65 CC 81`): normalization boundary, most often string compare or hashing.
   - Invisible/zero-width chars (`E2 80 8B`, `E2 80 8C`): pasted input or transforms that keep control chars.
4. Reproduce deterministically: write the minimal byte sample from the hex (not retyped text — retyping can re-normalize) and run it through the pipeline with instrumentation at each boundary (`cap test --target` harness or a one-off script; never commit instrumentation).
5. Identify the corrupting boundary: the first site where post-bytes differ from pre-bytes for the same logical text.
6. Fix at that boundary: explicit charset on decode/encode, BOM policy (strip once at ingestion or emit once at emit — never both), a single normalization form for compares/hashes (choose NFC for storage, state it), or a filter for control chars at input trust boundary. `cap diff` to scope.
7. Add a byte-exact regression test: assert the encoded output bytes (hex or Buffer compare), one case per corruption class from step 3.
8. Run `cap test`, `cap lint`, `cap typecheck`, `cap verify`; `cap memory add` the charset/codepoint facts for this pipeline.

## Verification
- [ ] Sample captured as bytes (hex) before any fix; corruption class named from the signature.
- [ ] Every charset/BOM/normalization boundary enumerated with its declared expectation.
- [ ] Corrupting boundary reproduced with the minimal byte sample.
- [ ] Fix applied at the corrupting boundary only (diff-scoped); no downstream patches.
- [ ] Byte-exact regression test covers each corruption class; `cap verify` passes.
- [ ] No invisible-character residue in committed fixtures (`cap diff` shows resulting bytes).

## Failure Handling
- Sample reconstructable only as rendered text (no raw bytes): record the rendered form and the locale/screen it was captured in; renderings can themselves re-normalize — flag the test as byte-approximate and state the uncertainty.
- Corruption occurs only at a cross-service boundary: `cap plugins` for the transport; include the wire sample (hex) in the report and fix the declared charset at both endpoints; a single fixed endpoint with a different declared charset still corrupts.
- Multiple classes present (mojibake AND BOM): fix the earliest boundary class first, re-capture hex, then re-classify — do not fix both at once; each class needs its own proof.
- Normalization mismatch is in a third-party comparator/hash: isolate the compare boundary in own code (normalize before the call) and report upstream with the NF example pair.

## Output Format
Report:
- Sample truth: hex of pre/post bytes plus the rendered symptom.
- Boundary inventory: decode/encode/BOM/normalize sites with declared vs. actual charset.
- Corruption class(es) proven, each with its signature bytes.
- Fix: one boundary changed, with the explicit charset/BOM/normalization policy stated.
- Regression tests: byte-exact cases per class; `cap verify` result.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap search`, `cap show`, `cap diff`, `cap test`).
- `src-api.md`: validate at the trust boundary — applies to input charset filtering.
- CONTRACT.md §7.3: bytes are the trace; never theorize from rendered output.