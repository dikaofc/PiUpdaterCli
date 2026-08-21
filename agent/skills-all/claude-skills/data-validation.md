---
name: data-validation
description: Validate and sanitize all untrusted input at trust boundaries.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [validation, security, data]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Input & Data Validation

## Objective
Reject malformed/unsafe input before it reaches domain or storage.

## Preconditions
- `cap repo` run; entry points and current validation reviewed (`cap search <validate|schema|parse>`).

## Workflow
1. Run `cap explore` for every untrusted boundary (HTTP, CLI args, uploads, env).
2. Define a schema per boundary; validate types, ranges, lengths, and formats.
3. Sanitize/encode at the boundary; never interpolate raw input into queries/HTML/Shell.
4. Return field-level errors; fail closed on unknown fields per policy.
5. Centralize parsing so one validator serves API and forms (see form-validation).
6. Record the validation rules with `cap memory add`.

## Verification
- [ ] All boundaries validated.
- [ ] No raw interpolation into queries/HTML/shell.
- [ ] Unknown-field policy explicit.
- [ ] Errors field-level, safe.

## Failure Handling
- If legacy lacks schema, add a thin validator at the edge first.
- If over-strict, loosen only with a test.

## Output Format
Validation design: per-boundary schemas, sanitization rules, and the central parser.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
