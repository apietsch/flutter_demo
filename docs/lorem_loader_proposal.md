# Feature Proposal: Configurable Lorem Text Loader

## Objective
Add a demo feature that loads text content from a configurable URL and displays it in a dedicated text window in the Flutter app.

## Scope
- Add a screen (or main view section) with:
  - URL input field (pre-filled with a default lorem endpoint)
  - `Load` button to fetch text
  - Scrollable text window for content display
  - Loading, empty, and error states
- Make the URL configurable at runtime through the input field.
- Keep architecture simple and suitable for a demo app.

## Proposed UX
1. User opens app and sees default URL prefilled.
2. User taps `Load`.
3. App fetches text from URL and shows progress indicator while loading.
4. On success, text appears in a scrollable read-only area.
5. On failure, a clear error message is shown with retry option.

## Technical Design
### Dependencies
- Add `http` package for network requests.

### Code Structure
- `lib/main.dart`
  - Wire the screen as home for the demo.
- `lib/features/lorem/data/lorem_repository.dart`
  - HTTP fetch logic.
- `lib/features/lorem/ui/lorem_loader_page.dart`
  - UI components and state management.

### State Model
Use `StatefulWidget` + local state for this demo:
- `String url`
- `String? loadedText`
- `String? errorMessage`
- `bool isLoading`

This keeps complexity low and is sufficient for a small demo.

### Fetch Flow
1. Validate URL format (`Uri.tryParse` + absolute URL check).
2. Reset error and previous text if needed.
3. Set `isLoading = true`.
4. Execute `http.get(uri)` with timeout (e.g. 10 seconds).
5. If status code 200:
  - Use response body as text window content.
6. Else:
  - Set friendly error state with status code.
7. Set `isLoading = false` in `finally`.

## Configuration Strategy
- Runtime configurable URL via text field.
- Optional default URL constant in code, e.g.:
  - `https://loripsum.net/api/1/short/plaintext`

Future extension (out of current scope):
- environment-based default URL using `--dart-define`.

## Error Handling
- Invalid URL input: inline validation message.
- Timeout/network issues: user-readable message.
- Non-200 responses: include HTTP status in message.
- Empty response body: show "No content returned" placeholder.

## Testing Plan
### Unit Tests
- Repository returns text for HTTP 200.
- Repository throws handled error for non-200.
- Timeout behavior maps to user-friendly error.

### Widget Tests
- Initial state renders input + load button.
- Loading indicator appears during fetch.
- Success shows fetched text in scrollable area.
- Error state appears for failed fetch.

## Implementation Plan
1. Add dependency in `pubspec.yaml` (`http`).
2. Create repository for fetch logic.
3. Build UI page with URL input + button + text window.
4. Connect fetch action and state transitions.
5. Add basic styling and spacing for readability.
6. Add tests (unit + widget).
7. Run `flutter analyze` and `flutter test`.

## Acceptance Criteria
- User can edit URL and press `Load`.
- App fetches text and displays it in a scrollable text window.
- Loading and error states are visible and understandable.
- Invalid URL does not crash app and is communicated clearly.
- Feature passes analysis and tests.

## Risks and Mitigations
- CORS limitations on web target:
  - Mitigation: document that some endpoints may fail in browser; iOS/macOS runs should still work.
- Third-party endpoint instability:
  - Mitigation: make URL editable and keep fallback endpoint suggestion in UI.

## Suggested Default Endpoint
`https://loripsum.net/api/1/short/plaintext`
