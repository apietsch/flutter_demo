## Why

The paper screening workspace exists in the app today, but it is not described in OpenSpec. Capturing it now makes the current behavior explicit and gives future changes a reliable requirements baseline instead of relying on UI code alone.

## What Changes

- Add an OpenSpec capability for the paper screening workspace based on the current implementation.
- Document the seeded-paper review flow, status filters, and decision actions for include, exclude, and maybe.
- Document the exclude-note behavior so future changes can preserve or intentionally evolve it.

## Capabilities

### New Capabilities
- `screening-workspace`: Covers the current paper screening workspace UI, seeded paper list, filtering, and status change behavior.

### Modified Capabilities

## Impact

- Affected code: `lib/features/screening/ui/screening_workspace_page.dart`
- APIs: No external API changes.
- Dependencies: No new dependencies.
- Systems: OpenSpec capability inventory and future change planning for the screening workspace.
