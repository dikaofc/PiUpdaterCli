---
name: seo-onpage
description: On-page SEO — title, meta, structured data, heading hierarchy, canonicals, sitemaps. Use when shipping or auditing a page for search.
category: Web Design
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# On-Page SEO

## Per page
- Title: ≤ 60 chars, primary keyword first, unique per page, compelling (CTR matters).
- Meta description: ≤ 155 chars, keyword + benefit + CTA; unique.
- URL: readable slugs, lowercase, hyphenated, keywords over numbers (`/pricing` not `/p123?id=4`).
- Headings: single h1 with the primary phrase; h2/h3 logical tree; no skipped levels.
- Content: answer intent; use the exact query phrase naturally in first 100 words.

## Structured data (JSON-LD)
- `Organization`, `WebSite` + SearchAction, `Article`, `BreadcrumbList`, `FAQPage` (only if text answers exist), `Product`+`Offer` (commerce), `Event`, `LocalBusiness`.
- Validate with Google Rich Results Test / Schema.org validator.

## Indexing
- Canonical on every page (self-referencing default); `noindex` on thin/duplicate pages.
- `robots.txt` allows CSS/JS/images (blocking breaks rendering); sitemap.xml + ping.
- Internal links: 3-8 per page with descriptive anchors; breadcrumbs.
- 404s: correct status code + helpful page with links.

## Health
- Single h1 per page; no duplicate titles/metas across site (script check).
- Remove thin content (< 200 words) or enrich it.
- HTTPS mandatory; redirects 301 not 302 for moved pages.

## Checklist
- [ ] Unique title/meta/URL per page
- [ ] JSON-LD where schema applies
- [ ] Canonical + sitemap + robots in place
- [ ] h1 unique, hierarchy clean
- [ ] No orphan pages (each reachable by link)