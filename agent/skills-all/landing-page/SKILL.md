---
name: landing-page
description: Design and build high-converting landing pages — structure, hero, messaging hierarchy, social proof, CTA, performance.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Landing Page

## Structure (top to bottom)
1. **Hero**: one promise — headline (benefit, not feature), subhead, 1 primary CTA + 1 secondary, product visual. Above the fold at 360px too.
2. **Social proof**: logos, testimonials, stats (numbers with context).
3. **Problem/agitation**: why the status quo hurts.
4. **Solution**: 3-6 benefit-driven feature cards; each = outcome + proof point.
5. **How it works**: 3 steps, screenshots/gif.
6. **Objection handling**: FAQ (accordion), pricing or comparison table.
7. **Final CTA**: repeat primary CTA + urgency (limited offer) with scatter of social proof.

## Rules
- One primary CTA per viewport; secondary CTAs visually weaker.
- Headline under 10 words; verb-first ("Ship X faster").
- Above the fold must answer: what is it, who for, why now.
- Real copy, not lorem. Numbers over adjectives ("2× faster" not "super fast").
- Testimonials with name/photo/role or company.
- GDPR: no fake urgency, no dark patterns.

## Performance (rank factor + conversion)
- Hero image ≤ 200KB, LCP ≤ 2.5s; `fetchpriority="high"` on hero img.
- Fonts subsetted; CLS 0 on CTA buttons.
- Mobile tap targets 44px.

## Checklist
- [ ] Headline states benefit in < 10 words
- [ ] 1 primary CTA per screen
- [ ] Every feature card: outcome + proof
- [ ] FAQ answers objection, not features
- [ ] Testimonials authenticated (name/photo)
- [ ] LCP fast, no layout shift