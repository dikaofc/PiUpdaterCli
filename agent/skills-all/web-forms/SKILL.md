---
name: web-forms
description: Design and build usable, accessible, validated web forms — layout, labels, states, errors, client+server validation.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Web Forms

## Layout
- One column for most forms; two-column only for short paired fields (first/last name).
- Label above input (best scan), 16px+ input text (prevents iOS zoom), 44px touch targets.
- Group related fields with `<fieldset>`/`<legend>`; horizontal grouping for checkboxes/radios.
- Input width signals expected length (postcode < email < address). Autocomplete attributes for address/name/email/etc.

## States
- Disabled, readonly, placeholder (never a replacement for label), required (`*` + screen-reader announcement), error, success.
- Placeholder: example format (`john@example.com`), gray 4.5:1 or hideable.

## Validation
- Client: `required`, `type=email/url/tel`, `minlength`, `pattern` — native where possible; JS only for cross-field rules (confirm password, conditional).
- Error style: red border + `aria-invalid="true"` + message via `aria-describedby` on the input, NOT color alone — add icon + text.
- Errors appear on blur/submit, not per keystroke (annoying); clear on valid input.
- Server: validate everything again — client validation is UX, server is security.
- On submit: disable button, show spinner, focus first invalid field, summarize errors in `role="alert"`.

## Checklist
- [ ] Every input has a real `<label>`
- [ ] Errors announced to screen readers
- [ ] No data loss on failed submit (preserve values)
- [ ] Double-submit prevented
- [ ] Server validates; client never trusted