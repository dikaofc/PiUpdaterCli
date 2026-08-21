# Checklist: Frontend

Verification checklist for browser-side code.

## Rendering & XSS

- [ ] No unsafe HTML injection (`unsafe-rendering.md`); framework auto-escaping
  not bypassed (no `dangerouslySetInnerHTML`/`innerHTML` on untrusted data,
  `v-html`, etc.)
- [ ] DOM sinks audited: `innerHTML`, `document.write`, `eval`, `location`,
  `postMessage` handling (`dom-sink-analysis.md`, `dom-xss.md`)
- [ ] User-provided content sanitized at render with context-appropriate encoding
- [ ] CSP configured and not bypassable (`content-security-policy.md`)

## Storage

- [ ] No secrets/tokens in localStorage unless justified and risk-accepted
  (`browser-storage.md`, `local-storage-security.md`)
- [ ] Session tokens prefer httpOnly cookies (`cookie-security.md`)
- [ ] Storage size and cross-origin exposure considered

## Data & API

- [ ] Frontend does not expose secrets or internal data unnecessarily
  (`frontend-data-exposure.md`, `frontend-source-exposure.md`)
- [ ] API calls use backend authorization; frontend auth state is not a security
  control (`frontend-auth-state.md`)
- [ ] CORS policy does not grant broad origin access (`cors-analysis.md`)

## Links & Navigation

- [ ] No open redirects in client routing (`open-redirect.md`)
- [ ] External links safe (`rel="noopener"`); postMessage targets validated

## Related

- `../skills/frontend/*`, `../skills/web/xss-analysis.md`
- `../checklists/api.md`
