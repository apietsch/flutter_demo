## Context

This feature introduced the first concrete data-fetch flow in the app. The goal was low complexity and high demo clarity, not enterprise-scale state architecture.

## Goals / Non-Goals

**Goals:**
- Provide configurable URL input and fetch action.
- Show clear loading, success, empty, and error outcomes.
- Keep implementation lightweight and testable.

**Non-Goals:**
- Complex state frameworks.
- Background caching/sync.
- Advanced content parsing/formatting.

## Decisions

1. Decision: Use `StatefulWidget` local state for UI behavior.
- Rationale: small scope and fast iteration.
- Alternative: introduce global state solution.
- Why not chosen: unnecessary overhead for demo feature.

2. Decision: Keep HTTP logic in repository layer.
- Rationale: separates network behavior from UI and improves testability.
- Alternative: call HTTP directly in page widget.
- Why not chosen: mixes concerns and complicates tests.

3. Decision: Validate URL and surface friendly errors.
- Rationale: avoids crashes and improves demo robustness.

## Risks / Trade-offs

- [Risk] Web CORS failures for third-party endpoints.
  - Mitigation: keep URL editable and document endpoint constraints.

- [Risk] Endpoint instability.
  - Mitigation: timeout handling and user-visible retries.
