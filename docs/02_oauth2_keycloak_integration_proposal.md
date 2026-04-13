# Proposal: OAuth2/OIDC Integration with Local Keycloak

## Goal
Add user login/logout to the Flutter app using OAuth2/OIDC against the local Keycloak setup in `infra/keycloak`.

## Context
- Keycloak is already running locally with:
  - Realm: `flutter-demo`
  - Client ID: `flutter-app` (public client, PKCE enabled)
  - Demo user: `demo` / `demo123`
- Discovery endpoint:
  - `http://localhost:8080/realms/flutter-demo/.well-known/openid-configuration`

## Scope (Phase 1)
Implement authentication for iOS simulator and macOS desktop in this app.

Included:
- Login via system browser (Authorization Code + PKCE)
- Token acquisition and in-memory session state
- Logout (OIDC end-session)
- Auth status UI in app (logged out / logged in)
- Basic protected action in app gated by login

Not included in Phase 1:
- Persistent secure token storage
- Refresh token background strategy
- Role-based authorization logic
- Production-grade secrets/config backends

## Recommended Technical Approach

### Flutter package choice
Use `flutter_appauth` for standards-based OAuth2/OIDC flows with PKCE.

Why:
- Mature native OAuth/OIDC support
- Good iOS compatibility
- Handles PKCE and system browser flow reliably

### App architecture
Create a small auth module:
- `lib/features/auth/config/auth_config.dart`
- `lib/features/auth/data/auth_service.dart`
- `lib/features/auth/state/auth_controller.dart`
- `lib/features/auth/ui/login_panel.dart`

Responsibilities:
- `auth_config.dart`: endpoints/client/scope constants
- `auth_service.dart`: wrapper around `flutter_appauth` authorize/token/logout calls
- `auth_controller.dart`: session state and UI events
- `login_panel.dart`: login/logout controls and user info rendering

## Configuration Plan
Use one centralized config object for local development:
- Issuer: `http://localhost:8080/realms/flutter-demo`
- Client ID: `flutter-app`
- Redirect URI: `com.example.flutterDemo:/oauth2redirect`
- Scopes: `openid profile email`

Future-ready improvement:
- Support env overrides via `--dart-define` for host/realm/client values.

## Platform Setup Plan

### iOS
- Add URL scheme to `ios/Runner/Info.plist` for callback:
  - `com.example.flutterDemo`
- Ensure redirect URI in app and Keycloak matches exactly.

### macOS
- Verify custom URL scheme callback support for app auth package.
- Keep outbound network entitlement (already added).

## UX Plan
Add an auth section at top of current main screen:
- If logged out:
  - `Sign in with Keycloak` button
- If logged in:
  - show `preferred_username` / `email`
  - show `Sign out` button

Protected action example:
- Keep current lorem loader feature visible, but disable `Load` until login in Phase 1
  (or show a small banner: "Please sign in to load data").

## Security Notes
- Use Authorization Code + PKCE only (no password grant in app)
- Keep tokens in memory for Phase 1
- Do not hardcode secrets (public client only)
- Validate issuer and use OIDC discovery endpoints

## Error Handling Plan
Handle and surface user-friendly messages for:
- User canceled login flow
- Browser/redirect mismatch
- Network errors to Keycloak
- Invalid issuer/client config
- Token exchange failure

## Testing Plan

### Unit tests
- `AuthController` state transitions:
  - logged out -> logging in -> logged in
  - login failure -> logged out with error
  - logout -> logged out

### Widget tests
- Login button visible when unauthenticated
- User info + logout visible when authenticated
- Protected action disabled when unauthenticated

### Manual integration checks
- Login on iOS simulator against local Keycloak
- Login on macOS desktop against local Keycloak
- Logout and verify session cleared

## Implementation Steps
1. Add dependency: `flutter_appauth`.
2. Add auth config/service/controller/UI files.
3. Wire auth UI into existing home screen.
4. Add iOS URL scheme callback config.
5. Implement login/logout flow with PKCE.
6. Gate one action in UI behind auth state.
7. Add unit/widget tests.
8. Run `flutter analyze` and `flutter test`.
9. Manual run on iOS simulator.

## Acceptance Criteria
- User can sign in with Keycloak from app.
- App receives tokens and transitions to logged-in state.
- Logged-in user info is displayed.
- User can sign out and returns to logged-out state.
- Login flow works on iOS simulator with local Keycloak.
- Code passes analysis and tests.

## Risks and Mitigations
- Redirect URI mismatch:
  - Mitigation: single source of truth in config + explicit plist setup.
- Localhost behavior differences by platform:
  - Mitigation: use issuer from discovery and verify per target; allow override via `--dart-define`.
- Web target differences:
  - Mitigation: keep Phase 1 focused on iOS/macOS; web can be Phase 2 with web-specific auth flow.

## Phase 2 (optional extension)
- Add secure token persistence (`flutter_secure_storage`)
- Add refresh token rotation handling
- Add role/claim-based feature toggles
- Add web OAuth flow support

