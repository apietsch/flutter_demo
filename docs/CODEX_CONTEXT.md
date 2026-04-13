# CODEX Context Handoff

## Snapshot
- Repository: `flutter_demo`
- Branch: `main`
- HEAD: `f8663b6`
- Remote sync: `main` is up to date with `origin/main`
- Platform focus: macOS host, iOS simulator, Chrome web

## Commit Timeline (authoritative)
1. `a5020da` - Add `AGENTS.md` for Flutter demo workflow
2. `7fc4dbb` - Scaffold Flutter app project
3. `76571e5` - Add proposal for configurable lorem text loader
4. `372fc55` - Implement configurable lorem text loader feature
5. `f8663b6` - Add iOS swipe demo and enable macOS outbound networking

## Implemented Features

### 1) Configurable lorem text loader
- UI allows entering/editing URL and pressing `Load`
- Fetches text over HTTP and renders in a scrollable text area
- Handles states:
  - loading spinner
  - success content
  - friendly error messages
  - empty state prompt

Primary files:
- `lib/main.dart`
- `lib/features/lorem/data/lorem_repository.dart`
- `lib/features/lorem/ui/lorem_loader_page.dart`
- `test/lorem_repository_test.dart`
- `test/widget_test.dart`

### 2) Swipe demo screen (for iOS gesture demo)
- Added dedicated page using `Dismissible` cards
- Left/right swipe actions with feedback labels
- Tracks last action and supports deck reset
- Entry point: top-right swipe icon in `LoremLoaderPage` app bar

Primary file:
- `lib/features/swipe/ui/swipe_demo_page.dart`

## Environment & Tooling Decisions
- Flutter installed via Homebrew cask (`flutter` command available on host)
- CocoaPods installed via Homebrew (instead of `gem install cocoapods`)
- iOS simulator runtime present and usable when Simulator service is healthy

## Platform-Specific Fixes Applied

### macOS network failure fix
Symptom observed: requests failing in macOS app context.
Root cause: app sandbox entitlements missing outbound client network permission.

Fix applied:
- Added `com.apple.security.network.client = true` in:
  - `macos/Runner/DebugProfile.entitlements`
  - `macos/Runner/Release.entitlements`

## Runbook

### Standard checks
```bash
flutter pub get
flutter analyze
flutter test
```

### Run targets
```bash
flutter run -d chrome
flutter run -d macos
flutter run -d <ios-simulator-device-id>
```

### If iOS simulator is not detected
```bash
open -a Simulator
xcrun simctl list runtimes
xcrun simctl list devices
flutter devices
```
If needed, boot a specific simulator:
```bash
xcrun simctl boot <device-id>
```

## Known Operational Notes
- `flutter run -d ios` did not always resolve automatically in this environment; using explicit simulator device ID was reliable.
- CoreSimulator service was intermittently unstable once; re-opening Simulator and booting device restored detection.
- `pod install` in `ios/` is not always needed for the current plugin set, but may be required as plugins are added.

## Existing Planning/Design Docs
- Feature proposal doc:
  - `docs/lorem_loader_proposal.md`

## Suggested Next Steps for Future Sessions
1. Add a small in-app preset list of safe demo URLs (plus custom URL field).
2. Add integration test coverage for swipe interactions.
3. Add `.vscode/launch.json` with explicit launch configs (`iOS`, `Chrome`, `macOS`).
4. If desired, split macOS entitlement fix into a dedicated commit/changelog entry (already included in `f8663b6`).

## Quick Reconstruction Prompt (copy/paste for future Codex)
"Read `AGENTS.md` and `docs/CODEX_CONTEXT.md` first. Continue from current `main` HEAD. Preserve existing lorem-loader and swipe-demo behavior. Validate with `flutter analyze` and `flutter test` before finalizing changes."
