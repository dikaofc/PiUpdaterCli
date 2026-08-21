---
name: json-validator
description: Validate JSON files and schemas, detect corrupted fixtures/config data, and pin the fix to the smallest repair.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for indexing, search, and verification steps.
metadata:
  category: review
  tags: [json, schema, fixtures, config]
---

# JSON Validator
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Scan JSON files in the repository (fixtures, config, test data), classify each as well-formed / schema-invalid / corrupted, and when permitted produce the smallest repair that restores validity without changing semantics.

## Preconditions
- Repository indexed (`cap index --refresh`); JSON targets located or known.
- A schema file (where one exists) is identified; unrelated / non-schema JSON is validated for well-formedness only.
- User consent obtained for any repair; the default workflow is read-only.

## Workflow
1. Run `cap status` and `cap index --refresh` to get repo state and a fresh index.
2. Locate JSON files: `cap search` with patterns (`*.json`, excluding `node_modules`/lockfiles if too noisy). Record the full list.
3. Read each file with `cap show <file>` (or `cap search` for targeted probes) and run the parse check: `JSON.parse` per file, classifying results as OK / malformed with error offset / empty / huge, and record a parse report.
4. Detect schema candidates with `cap search` (e.g. `*.schema.json`, `schemas/` dir) and cross-check each data file against its schema when one exists.
5. Classify findings: corrupt data (truncation, double-encoded, BOM issues), schema violations (missing/extra/mistyped fields), and stylistic anomalies (trailing commas, unicode escapes) — each with file:line and the violating fragment.
6. For suspicious semantic damage, check whether other files or code read that file (`cap explore <symbol>` / `cap search <filename>`) to determine blast radius before proposing a repair.
7. With user approval, repair the smallest unit: markdown of the corrupted node only, then re-parse and re-validate against the schema.
8. Re-run the parse+validate pass over all touched files; run `cap verify` and `cap diff` to prove nothing else changed.

## Verification
- [ ] Parse pass executed over every found JSON file; every file classified.
- [ ] Schema files located and matched to their data files (where they exist).
- [ ] Each finding has file:line and the offending fragment reproduced.
- [ ] Blast radius (code reading the file) checked for repaired files.
- [ ] Post-repair: every repaired file parses and validates against schema.
- [ ] `cap verify` passes and `cap diff` shows only intended repairs.

## Failure Handling
- If a JSON file is binary-corrupted (not text-repairable): mark it unrecoverable, do not guess-repair, and report it for regeneration from source.
- If no schema exists for a file: validate well-formedness only and say so; do not invent schema requirements.
- If a repair changes semantics (same parse, different data): revert with `cap rollback --task <id>` and re-apply field-by-field.
- If the JSON corpus is very large: validate in batches, report per-batch results, never claim a full pass on a partial run.

## Output Format
Final report:
- Corpus size and per-file status table (path, bytes, parse result, schema match).
- Findings: category, file:line, fragment, severity, suggested repair.
- Repairs applied (only with consent) and their re-validation results.
- Blast-radius notes for repaired files; `cap verify` and `cap diff` outcomes.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap index --refresh`, `cap search`, `cap show`, `cap explore`, `cap verify`, `cap diff`, `cap rollback`.