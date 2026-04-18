## Why

The swipe demo no longer supports the app's current direction and has become a distraction while testing other flows. Removing it now simplifies the demo surface area and avoids spending more time debugging a page that is no longer needed.

## What Changes

- Remove the swipe demo page from the app and stop exposing it from the main demo UI.
- Remove swipe-demo-specific navigation affordances, labels, and any dead imports tied to that screen.
- Clean up related tests or references so the app reflects the remaining supported demos only.

## Capabilities

### New Capabilities
- `demo-entry-points`: Defines which demo pages are exposed from the app shell and ensures retired demos are removed cleanly from navigation and code references.

### Modified Capabilities

## Impact

- Affected code: `lib/features/lorem/ui/lorem_loader_page.dart`, `lib/features/swipe/ui/`, and any app wiring or tests that reference the swipe demo.
- APIs: No external API changes.
- Dependencies: No new dependencies.
- Systems: Flutter app navigation and demo page availability.
