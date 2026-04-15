## Why

The app needed a simple demo feature to fetch and display remote text from a configurable URL. This establishes a concrete user-facing flow for networking, loading states, and error handling.

## What Changes

- Add a lorem text loader UI with editable URL field.
- Add load action with loading, success, and error states.
- Add repository-based HTTP fetch logic with timeout and status handling.
- Add tests for repository behavior and widget interactions.

## Capabilities

### New Capabilities
- `configurable-lorem-loader`: Load remote text from an editable URL and present it in a scrollable text area with resilient UX states.

### Modified Capabilities
- None.

## Impact

- Affected code: `lib/features/lorem/**`, app startup/home wiring.
- Dependencies: `http` package.
- UX impact: introduces the app's primary data-loading demo workflow.
