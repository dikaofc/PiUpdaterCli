---
name: ui-forms
description: Validate and polish form UX against the deep checklist — helper text, inline errors, keyboard flow, mobile keyboards.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# UI Forms (deep)

## Beyond basics (`web-forms`)
- Helper text: live with the input (`aria-describedby`), not hidden in tooltips; show rules that users will actually violate (password min length) proactively as they type.
- Inline validation: validate on blur; show success checkmark only when it adds value; never block submit with silent failures.
- Focus flow: Enter submits (unless textarea/multiline), Esc if autocomplete open cancels it and restores field, Tab order matches form reading order with no traps.
- Autofill: `autocomplete` values per field (`name`, `email`, `billing address-line1`, `cc-exp`); browser autofill yellow flushes — re-theme with `:-webkit-autofill`.
- Mobile: correct `inputmode` (numeric, tel, email, url, decimal), `enterkeyhint` (`go`, `next`, `done`), phone/tel inputs keep `type="tel"` not `type="text"`.
- Length limits: `maxlength` only when truncation risk is real (slugs, codes); otherwise let it breathe and error politely.
- Paste handling: accept pasted phone/date re-formats; normalizing input is good, overwriting user paste is not.
- Session: preserve answers on accidental navigation (keep values in localStorage until submit).
- Submit: single submission guaranteed (flag + disable), success feedback screen without destructive refresh (use `replaceState` not full reload).

## Checklist
- [ ] Blur validation + submit validation both wired
- [ ] Mobile keyboard type per input
- [ ] Enter/Esc behavior sane
- [ ] Semantic autocomplete everywhere
- [ ] Re-entered values survive refresh