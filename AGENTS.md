# AGENTS.md

## Project Goal
Build and iterate on a Flutter demo app inside this repository.

## Environment
- OS: macOS
- iOS tooling: Xcode installed (for iOS Simulator)
- Repo root: this directory

## Working Agreement for Agents
- Keep changes focused and small.
- Prefer `flutter` CLI for project scaffolding and validation.
- Do not commit generated build artifacts (`build/`, `.dart_tool/`, etc.).
- Before finalizing significant changes, run formatting and analysis.

## Initial Bootstrap Steps
1. Verify Flutter installation:
   - `flutter --version`
   - `flutter doctor`
2. Create app in-place (run only once in this repo root):
   - `flutter create .`
3. Get dependencies:
   - `flutter pub get`

## Useful Daily Commands
- Run on iOS simulator:
  - `flutter run -d ios`
- List devices:
  - `flutter devices`
- Static checks:
  - `flutter analyze`
- Tests:
  - `flutter test`
- Format Dart code:
  - `dart format .`

## iOS Notes
- If CocoaPods setup is needed:
  - `cd ios && pod install && cd ..`
- If signing or simulator issues appear, re-check:
  - `flutter doctor -v`

## Suggested Next Step
Scaffold the Flutter app now with:

```bash
flutter create .
```
