## Context

Native logout previously invoked OIDC end-session, which caused an iOS prompt that looked like a new sign-in attempt. The app needed a smoother local sign-out UX.

## Goals / Non-Goals

**Goals:**
- Remove popup-inducing logout behavior.
- Keep local logout immediate and predictable.
- Preserve existing login/refresh mechanisms.

**Non-Goals:**
- Full server-side global logout guarantees.
- Session revocation orchestration across all devices.

## Decisions

1. Decision: Add config flag for local-only logout mode.
- Rationale: explicit behavior control and easy rollback.

2. Decision: Default to local-only logout.
- Rationale: optimize UX for app sign-out action.

## Risks / Trade-offs

- [Risk] Server/browser SSO session remains valid after app logout.
  - Mitigation: document behavior and allow opt-out via config flag.
