---
name: e2e-testing
description: Write reliable end-to-end tests — Playwright/Cypress patterns, selectors, waits, auth seeding, parallel shards.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# E2E Testing

## Tooling
- Playwright (default: fast, auto-wait, trace viewer) or Cypress (older/familiar). One per project — no dual frameworks.

## Reliability rules (flaky prevention)
- **Auto-wait, don't sleep**: `page.getByRole('button', {name: 'Save'}).click()` waits for actionability; never `page.waitForTimeout(2000)` — deterministic conditions only.
- Selectors: `getByRole`/`getByTestId` (data-testid) — never CSS classes/positions (fragile). Test ids on interactive elements only.
- Scope assertions: `expect(page.getByRole('alert')).toContainText('saved')` — exact content, not regex soup.
- Full page load expectations: `await page.waitForLoadState('networkidle')` sparingly (dead spots); prefer waiting on the UI state you need.
- Parallel: shard by spec file (CI); isolated state per test (unique user email + fresh storage).

## Auth/seeding
- **API-level login/session seeding** (set cookie/token via storage state) — one login per suite not per test; UI login tested once.
- Data: seed via API/DB in `beforeAll`; never rely on prod UI clicks to create data in test.

## Coverage shape
- Happy path per critical flow (signup, pay, admin action) + 2-3 edge branches (error toast, empty state, permissions deny).
- Cross-flow: checkout → payment webhook → order state; notifications read/unread.

## Debugging a failure
- Trace viewer (Playwright) / screenshots + video on failure — the artifact IS the repro; attach to CI job.
- Retries: 1-2 with backoff acceptable for network-bound, but investigate ≥2 consecutive flakes (root-cause, don't patch around).
- Locally: headed run + step-through (`--debug`); isolate with `--grep`.

## Checklist
- [ ] Role/test-id selectors only; no sleeps
- [ ] Session seeded via API; data seeded, not clicked
- [ ] Critical flows + error branches covered
- [ ] Parallel shards; isolated test state
- [ ] Failures carry trace/screenshot artifacts