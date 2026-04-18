## Context

The app currently launches into the lorem loader screen and exposes extra demo destinations from that page, including the swipe demo. The swipe demo is not part of the app's intended forward path, and recent debugging on that screen showed that keeping it around adds maintenance cost without helping the supported auth and loader flows.

## Goals / Non-Goals

**Goals:**
- Remove the swipe demo from the visible app experience.
- Remove code references that keep the swipe demo feature wired into the app.
- Keep the remaining lorem loader and screening workspace flows intact.

**Non-Goals:**
- Redesign the lorem loader page.
- Change auth, screening workspace, or loader behavior.
- Replace the swipe demo with a new feature.

## Decisions

- Remove the swipe demo entry point from the lorem loader app bar.
  Rationale: the main issue is user-facing exposure of a retired demo, so removing the navigation affordance immediately removes the feature from the reachable UI.
- Delete the swipe demo feature module if nothing else references it.
  Rationale: removing dead code prevents future confusion and avoids debugging a page that should no longer exist.
- Update tests and imports as part of the same cleanup.
  Rationale: the change should leave the codebase in a consistent state with no dangling references.

## Risks / Trade-offs

- [Risk] A hidden reference outside the main screen still points to the swipe demo. -> Mitigation: search the repo for `SwipeDemoPage` and related feature paths before implementation is complete.
- [Risk] Removing the demo changes expectations for anyone using it during ad hoc UI testing. -> Mitigation: keep the screening workspace and lorem loader paths unchanged so the remaining demo surface stays stable.
- [Risk] Test coverage may implicitly assume the swipe button exists. -> Mitigation: update or remove any assertions tied to that button during implementation.
