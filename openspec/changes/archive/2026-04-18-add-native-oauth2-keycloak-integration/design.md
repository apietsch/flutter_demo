## Context

Local Keycloak realm/client were available, and the app required standards-based login on iOS/macOS. Existing UI needed auth state integration without major restructuring.

## Goals / Non-Goals

**Goals:**
- Implement PKCE login/logout for native targets.
- Keep auth logic modular and testable.
- Expose auth status in UI and gate protected actions.

**Non-Goals:**
- Web auth implementation.
- Long-lived persistent sessions and advanced token lifecycle policy.

## Decisions

1. Decision: Use `flutter_appauth` for native OAuth2/OIDC.
- Rationale: standards compliance and stable native integration.

2. Decision: Introduce `AuthService` + `AuthController` boundaries.
- Rationale: isolate provider details and centralize session state.

3. Decision: Gate lorem load action behind auth state.
- Rationale: provide concrete protected-action behavior in demo app.

## Risks / Trade-offs

- [Risk] Redirect URI mismatch breaks callback flow.
  - Mitigation: single config source plus platform callback configuration.

- [Risk] Native-only auth path excludes web/windows initially.
  - Mitigation: defer platform adapter work to follow-up change.
