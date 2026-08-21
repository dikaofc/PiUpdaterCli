# Language Guide: CSS

Security and correctness analysis notes for CSS.

## Dangerous Patterns

- **`url()` in CSS from untrusted data** — may trigger requests (privacy leak,
  SSRF-adjacent exfil); validate URLs, disallow `javascript:` in CSS contexts.
- **`expression()` (legacy IE)** — script execution in CSS (historical).
- **CSS injection:** user-controlled values injected into inline `style`
  attributes or `<style>` blocks — attribute injection and UI redressing
  (`header-injection.md` analogies, `xss-analysis.md`).
- **Data exfiltration via CSS** (attribute selectors + `url()` requests) —
  mitigate with CSP and by not placing secrets in predictable DOM attributes
  (`content-security-policy.md`).
- **`@import` of external stylesheets** — supply-chain and privacy risk.
- **User content styling** with `!important` overriding UI overlays — clickjacking
  mitigation bypass (`clickjacking.md`).

## Common Mistakes

- Sanitizing HTML but passing raw user strings into `style="..."`.
- CSP `style-src 'unsafe-inline'` broadly allowed — weakens XSS defenses
  (`content-security-policy.md`).
- Allowing user-supplied `href`/`url()` without allow-lists.

## Input Handling

- Never concatenate user input into CSS values; validate against allow-lists;
  encode quotes and parentheses if embedding.

## Testing

- CSS injection tests: assert no attribute/selector breakouts; renderer fuzzing.

## Related

- `../skills/web/content-security-policy.md`
- `../skills/web/clickjacking.md`
- `../skills/web/xss-analysis.md`
