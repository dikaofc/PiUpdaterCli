---
name: mobile-testing
description: Test mobile apps — device matrix, emulator vs real device, e2e frameworks, permissions, network conditions, release readiness.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Mobile Testing

## Matrix (pick: OS major × device class × resolution)
- iOS: latest + previous major, iPhone SE-class small screen + modern flagship; Android: API 35+ latest, API 28-30 old-but-active, split-screen/foldable optional.
- Reality: real devices for sensors/perf (GPU), emulators for scale/CI speed — hybrid: emulator matrix in CI, real-device smoke pre-release (device farm optional).

## E2E frameworks
- **Detox** (React Native) — native gestures, stable sync; **Maestro** (YAML, fast, good for flows); **Appium** (legacy/WebView heavy).
- Appium caveats: native+webview interplay flaky — prefer Maestro/Detox for RN.
- Reliability same as `e2e-testing`: role/test-id locators, auto-wait, per-test app state reset (`launchArgs`, clear storage), screenshots/video on failure.

## What to cover (mobile-specific)
- **Permissions flow**: first-launch prompts (location/camera/notifications) — accept/deny both paths, denial ≠ crash.
- **Network**: airplane-mode offline UX, slow 3G (throttle via emulator/devtools), reconnect behavior (queue/retry), partial connectivity (wifi-no-internet).
- **Lifecycle**: background → foreground (state restore, no double-fetch), OOM relaunch (release memory under stress), rotation/split-screen layout sanity, deep links (cold start vs warm).
- **Gestures**: swipe-to-refresh, back-gesture vs hardware back (Android), long-press menu; keyboard: form flow Enter, autofill.
- **Persistence**: app kill → relaunch keeps draft/auth (or logs out by design), async-storage corrupt → graceful.

## Release readiness
- Release build (not dev) tested: icons/splash, bundle size, permissions of shipped variant, signing; store review preview (TestFlight/internal track).
- Crash reporting smoke: Sentry-style source-mapped stack trace; ANR detection (Android) run.

## Checklist
- [ ] Matrix covers latest + legacy major OS
- [ ] Permission accept/deny both covered
- [ ] Offline/slow-network/relaunch scenarios tested
- [ ] Gestures + back navigation + deep links
- [ ] Release build + crash mapping verified