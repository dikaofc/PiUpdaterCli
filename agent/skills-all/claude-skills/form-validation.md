---
name: form-validation
description: Build forms with accessible validation, inline errors, and safe submission.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: coding
  tags: [forms, validation, frontend]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Form & Validation UX

## Objective
Capture user input correctly with clear feedback and no data loss.

## Preconditions
- `cap repo` run; form components and current validation reviewed (`cap explore <form|input|validation>`).

## Workflow
1. Run `cap explore` for forms and their validation rules.
2. Validate on blur/submit (not every keystroke) with accessible error messages linked to inputs.
3. Enforce rules both client- and server-side (see data-validation); never trust the client.
4. Preserve input on error; disable double-submit; show pending state.
5. Support labels, hints, and `aria-invalid`/`aria-describedby` for assistive tech.
6. Record the validation schema with `cap memory add`.

## Verification
- [ ] Errors accessible + inline.
- [ ] Server re-validates.
- [ ] No double-submit; input preserved.
- [ ] ARIA wired on fields.

## Failure Handling
- If schema diverges client/server, share one source.
- If async validation, debounce + cancel.

## Output Format
Forms design: validation schema, UX states, and the client/server parity check.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
