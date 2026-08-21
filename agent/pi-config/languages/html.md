# Language Guide: HTML

Security and correctness analysis notes for HTML output and markup.

## Dangerous Patterns

- **Raw insertion of untrusted data into HTML** without context-aware encoding —
  XSS (`xss-analysis.md`, `stored-xss.md`, `reflected-xss.md`).
- **Event handler attributes** (`onclick`, `onerror`, etc.) built from data.
- **`javascript:` URLs** in `href`/`src` — script execution (`open-redirect.md`
  adjacent, `xss-analysis.md`).
- **`<script>`/`<style>`/`<iframe>`/`<object>` injection** — persistent XSS.
- **Unsafe attributes:** `srcdoc`, `formaction`, `data:` URLs.
- **MIME sniffing:** serving user content with wrong Content-Type — XSS
  (`mime-confusion.md`).
- **Missing `noscript` handling** — DOM clobbering (`dom-xss.md`).
- **`id` collisions with global names** — DOM clobbering primitives.

## Common Mistakes

- Escaping for the wrong context (escaping HTML when data lands in an attribute
  or JS context) (`encoding-validation.md`).
- Double-encoding or missing charset declaration (`<meta charset>`).
- Using `innerHTML` for static markup that includes user data
  (`unsafe-rendering.md`).
- Building URLs/links without validation (`url-validation.md`).

## Input Handling

- Context-aware output encoding: HTML body, attributes (with quote encoding),
  script context, URL context, style context — each has a distinct encoding
  (`encoding-validation.md`).
- Validate URLs against allow-lists; no `javascript:`/`data:` schemes.

## Structure

- Correct nesting and escaping prevent parser-confusion bugs.
- CSP reduces impact but is not a substitute for encoding
  (`content-security-policy.md`).

## Testing

- XSS tests per insertion context; automated DOM-based detection
  (`dom-sink-analysis.md`); fuzz renderers with hostile input
  (`fuzzing-strategy.md`).

## Related

- `../skills/web/*` (XSS family, headers, CSP)
- `../skills/frontend/unsafe-rendering.md`
