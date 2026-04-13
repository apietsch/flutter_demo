# Proposal: Secure Token Storage + Remember Me (Keycloak)

## Goal
Provide a durable login experience where users can stay signed in across app restarts and optionally across long idle periods (days/weeks), while keeping OAuth2 security best practices.

## Why This Matters
1. Secure token storage
- Keeps refresh/session tokens safely on-device across app restarts.
- Without it, the app loses session state when closed and users must re-login.

2. Remember Me (server-side)
- Uses longer Keycloak session timeouts for opted-in sessions.
- Allows refresh token usage after long idle periods (subject to configured policy).

## Current State
- Secure storage is already present (`flutter_secure_storage`) and used for persisted session state.
- Refresh flow is implemented (restore session, refresh on-demand/proactive).
- Keycloak realm currently uses relatively short default SSO idle timeout for long-lived consumer-like UX.

## Scope
Implement both explicitly and end-to-end:
1. Harden and document secure token storage behavior.
2. Add app-level Remember Me UX + flow integration.
3. Configure Keycloak Remember Me policies to support long session duration.
4. Validate behavior with manual and automated tests.

## Security Principles
- Keep access tokens short-lived.
- Use refresh/session renewal rather than long-lived access tokens.
- Store tokens only in platform secure storage.
- Avoid logging tokens or sensitive auth payloads.

## Design

### A) Secure Token Storage
Files:
- `lib/features/auth/data/auth_session_store.dart`
- `lib/features/auth/data/auth_service.dart`
- `lib/features/auth/state/auth_controller.dart`

Plan:
1. Ensure only required fields are persisted (access, refresh, id token, expiry metadata, claims needed for UI).
2. Add corruption handling: if storage payload invalid -> clear and force clean login.
3. Add explicit clear-on-signout and clear-on-refresh-failure behavior (already present; verify with tests).
4. Add short architecture notes in docs for future maintainers.

### B) Remember Me UX + Auth Request Integration
Files:
- `lib/features/auth/ui/login_panel.dart`
- `lib/features/auth/state/auth_controller.dart`
- `lib/features/auth/data/auth_service.dart`

Plan:
1. Add a `Remember me` checkbox in login UI.
2. Propagate user choice from UI -> controller -> auth service.
3. Include remember-me hint/parameter in auth request where supported.
4. Persist the remember-me preference locally (non-sensitive) to prefill next login.

Note:
- Keycloak login page can also present its own Remember Me checkbox if enabled.
- If app-level toggle is used, it should align with Keycloak behavior and not conflict with server form behavior.

### C) Keycloak Server Configuration
Target: realm `flutter-demo`

Plan:
1. Enable `Remember Me` in realm settings.
2. Configure longer remember-me session values than standard session values.
   - Example baseline:
     - Standard idle: 30 min
     - Standard max: 10 h
     - Remember-me idle: 7 days
     - Remember-me max: 30 days
3. Keep access token lifespan short (e.g., 5–15 min).
4. Optionally enable refresh token rotation depending on security posture.

Implementation style:
- Prefer declarative realm config update under `infra/keycloak/realm/` so setup remains reproducible.

## Testing Plan

### Unit tests
- Storage load/save/clear behavior including invalid payload fallback.
- Auth controller sign-in with remember-me preference propagation.
- Refresh failure clears session and persisted state.

### Widget tests
- Login panel shows `Remember me` toggle.
- Toggle state affects sign-in invocation.

### Manual tests
1. Sign in with Remember Me off:
   - verify shorter session behavior.
2. Sign in with Remember Me on:
   - close/reopen app and verify silent restore.
   - verify refresh still works after extended idle interval (using shortened test windows first).
3. Sign out:
   - ensure local tokens are removed and re-login is required.

## Acceptance Criteria
1. App can restore session after restart without forcing login (when session still valid).
2. Remember Me option is visible and functional in login flow.
3. Keycloak remember-me settings are enabled and documented.
4. Long-idle users who selected Remember Me can continue without immediate re-login (per configured policy).
5. `flutter analyze` and `flutter test` pass.

## Risks and Mitigations
- Risk: false expectation from UI toggle if server policy not aligned.
  - Mitigation: apply realm config changes in same feature and document effective timeouts.

- Risk: local storage corruption leads to auth loop.
  - Mitigation: clear invalid state and present explicit login error once.

- Risk: security tradeoff from very long sessions.
  - Mitigation: keep access tokens short and rely on server-controlled revocation/session management.

## Step-by-Step Implementation Plan
1. Add/confirm Keycloak remember-me realm settings in versioned realm config.
2. Add `Remember me` UI toggle and state wiring.
3. Pass remember-me choice into sign-in request handling.
4. Harden session store error handling and test coverage.
5. Update docs (`CODEX_CONTEXT.md` + OAuth reports).
6. Run analyze/test and validate manually with Keycloak container.

