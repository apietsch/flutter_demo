## Context

Phase 1 auth proved login/logout but lacked durable session continuity. Users reopening the app had to login repeatedly, and long-idle behavior required explicit policy.

## Goals / Non-Goals

**Goals:**
- Persist and restore sessions securely.
- Refresh tokens before expiry and recover from stale state.
- Align app behavior with Keycloak remember-me policy.

**Non-Goals:**
- Role-based authorization.
- Multi-device session orchestration.

## Decisions

1. Decision: Use secure storage-backed session store abstraction.
- Rationale: keep security boundary centralized and replaceable.

2. Decision: Add best-effort persistence with graceful failure handling.
- Rationale: auth session validity should not fully depend on storage writes succeeding.

3. Decision: Keep access tokens short-lived and rely on refresh/session policy.
- Rationale: balance UX with security best practices.

## Risks / Trade-offs

- [Risk] Storage or entitlement issues on specific platforms.
  - Mitigation: best-effort persistence and explicit platform configuration docs.

- [Risk] Remember-me expectations diverge from server policy.
  - Mitigation: document and version Keycloak timeout settings.
