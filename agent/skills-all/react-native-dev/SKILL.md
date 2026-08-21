---
name: react-native-dev
description: Build React Native apps — navigations, state, performance, platform differences, safe areas, release builds.
category: Frontend
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# React Native Development

## Architecture
- Expo when possible (managed build, OTA updates, easy native modules); bare RN/CNG when you need full-native control.
- Navigation: React Navigation (JS) or Expo Router (file-based); deep links via linking config; typed routes.
- State: server state via TanStack Query; global UI state via Context/Zustand — don't put everything in Redux.
- Styling: RN style objects / NativeWind (Tailwind mapping); no web CSS. `flex`, not float.
- Async storage for persistence; safe-area via `react-native-safe-area-context` (not raw `StatusBar`).

## Platform
- Android vs iOS differences: back button (Android hardware back → navigation), keyboard handling (`KeyboardAvoidingView` behavior iOS='padding' Android='height'), fonts (iOS holds system fonts by default), permissions.
- Safe areas top/bottom insets; `Platform.select` for platform branches; test on both before shipping.
- Icons: `@expo/vector-icons`; images: RN resize modes `contain`/`cover`, `Image` caching strategies — `expo-image` for advanced.

## Performance
- `FlatList` over `ScrollView` for long lists (windowed); `windowSize`/`initialNumToRender` tuned; `Memo` components with stable props; `useMemo` heavy transforms; avoid Anonymous closets in render.
- JS thread: keep heavy work in `InteractionManager` or worklets; images: cache thumbnails; videos: streaming URLs.
- Bundle size: tree-shake, code-split with `Suspense`/dynamic import.

## Release
- EAS build (`eas build`) — dev build with `expo-dev-client`; app icon/splash config; `Google Play` AAB vs iOS provisioning; version number bumps via `app.json`.
- OTA updates `expo-updates` limited to JS changes; native changes need store build.
- Debug: Metro, `Debugger`, React DevTools, `LogBox` for warnings.

## Checklist
- [ ] Safe areas handled everywhere
- [ ] Lists are FlatList
- [ ] Auth/navigation state lifted correctly
- [ ] Tested on both platforms
- [ ] Release build passes EAS/local, icons+splash set