## Why

The app's current authentication flow is native-first and does not provide a reliable web login path for Chrome. We need a platform-appropriate OAuth2/OIDC web flow now so the same app can authenticate on web while preserving the already working iOS/macOS experience.

## What Changes

- Add a web-specific OAuth2/OIDC login/logout flow (Authorization Code + PKCE) for Keycloak.
- Introduce platform-aware auth wiring so web uses a web auth adapter while iOS/macOS keep `flutter_appauth`.
- Add web callback/redirect handling and configuration for local/dev and production domains.
- Define web session persistence and refresh behavior with explicit security tradeoffs.
- Add documentation for Keycloak web client setup (redirect URIs, web origins, CORS-related expectations).

## Capabilities

### New Capabilities
- `web-oidc-auth`: Browser-native Keycloak OAuth2/OIDC flow for Flutter Web, including login, callback handling, token exchange, refresh behavior, and logout.
- `platform-auth-adapter`: Platform-based auth selection so each target (web vs native) uses the correct auth implementation behind a shared app interface.

### Modified Capabilities
- None.

## Impact

- Affected code: auth configuration, auth service wiring, platform bootstrap/composition in app startup, and auth state lifecycle.
- Affected systems: Keycloak client configuration for web redirect URIs and allowed origins.
- Dependencies: likely addition of a web-capable OAuth/OIDC library (or JS interop wrapper) while retaining `flutter_appauth` for native.
- Runtime behavior: login/logout behavior becomes platform-specific under a shared controller contract.
