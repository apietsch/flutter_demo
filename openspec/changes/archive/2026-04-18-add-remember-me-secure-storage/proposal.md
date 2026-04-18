## Why

Users needed durable sign-in across app restarts and longer idle windows while maintaining secure token handling. The initial auth integration was in-memory focused and needed persistent session support.

## What Changes

- Persist auth session data securely on-device.
- Restore session at startup and support token refresh lifecycle.
- Introduce remember-me-oriented realm/session policy alignment with Keycloak.
- Add validation and fallback behavior for corrupted persisted state.

## Capabilities

### New Capabilities
- `persisted-auth-session`: Secure auth session persistence, restore, and refresh lifecycle handling.
- `remember-me-policy`: App/server-aligned remember-me behavior for longer-lived user sessions.

### Modified Capabilities
- `native-oidc-auth`: Session lifetime behavior changes from in-memory-only to persisted+refresh-aware.

## Impact

- Affected code: auth session store, auth controller refresh/persist flow, auth UI state behavior.
- Dependencies: `flutter_secure_storage` and related platform packages.
- Server impact: Keycloak realm remember-me settings and timeouts.
