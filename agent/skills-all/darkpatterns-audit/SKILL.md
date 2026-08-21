---
name: darkpatterns-audit
description: Detect and remove dark patterns — deceptive opt-ins, hidden costs, fake scarcity, forced choice, maze navigation.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Dark Patterns Audit

## Patterns to hunt
- **Trick question**: checkbox says "Don't email me" meaning it *does* email. Or double negatives.
- **Preselect**: opt-in boxes checked by default (GDPR/CCPA violation — consent must be explicit).
- **Hidden cost**: fees revealed at checkout step final; shipping costs hidden until payment.
- **Confirmshaming**: decline button shames ("No thanks, I'm not smart enough").
- **Forced action**: must enter email to read article; must install app to use web feature.
- **Fake urgency/scarcity**: fabricated countdowns, "only 3 left" that never changes.
- **Misdirection**: uninstall/decline button styled to blend in, primary style on the wrong choice.
- **Roach motel**: easy to sign up, near-impossible to cancel (cancel buried in settings, requires call).
- **Privacy zuckering**: privacy-sapping defaults hidden in options.

## Red flags in code
- `checked` attribute on consent boxes; `opt-out` defaults; countdowns resetting each visit; cancel/delete links 404 or looping.

## Remediation
- Declare defaults: opt-in for email/marketing (double opt-in for email).
- Price transparency: list all fees before checkout entry; shipping on first price display.
- Cancel path: same clicks as signup, works in-app, no retention gauntlet.
- Visual honesty: both choices same weight; destructive action styled warning.
- Test with fresh users; log drop-off at cancellation steps.

## Checklist
- [ ] No pre-checked boxes
- [ ] Prices inclusive up front
- [ ] Cancel/enable equals disable in friction
- [ ] No countdowns/gamified scarcity
- [ ] Decline is a peer, not a shameful link