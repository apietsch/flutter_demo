## Why

The app needed secure user authentication for protected actions using local Keycloak. Native iOS/macOS support was the first target to establish a reliable OAuth2/OIDC baseline.

## What Changes

- Add login/logout integration using OAuth2/OIDC Authorization Code + PKCE.
- Add auth service, controller, and login UI panel.
- Gate protected actions by auth state.
- Configure native callback URI handling and auth constants.

## Capabilities

### New Capabilities
- `native-oidc-auth`: Native iOS/macOS sign-in/sign-out and session state handling against Keycloak.

### Modified Capabilities
- `configurable-lorem-loader`: Load action behavior changes to require authentication.

## Impact

- Affected code: `lib/features/auth/**`, main app wiring, lorem UI auth gating.
- Dependencies: `flutter_appauth`.
- Platform config: iOS/macOS callback and project signing settings.
