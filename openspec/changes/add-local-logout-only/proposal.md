## Why

OIDC end-session on iOS introduced an unwanted web-auth popup during logout, creating UX friction for routine sign-out actions.

## What Changes

- Change logout behavior to local-only session clear by default.
- Skip browser-based end-session call when local logout mode is enabled.
- Keep login and refresh behavior unchanged.

## Capabilities

### New Capabilities
- `local-only-logout`: App logout flow that clears local session without triggering external browser sign-out.

### Modified Capabilities
- `native-oidc-auth`: Logout behavior changes from end-session-first to local-only default.

## Impact

- Affected code: auth config flag and auth service sign-out path.
- UX impact: no iOS web-auth popup on logout.
- Trade-off: IdP/browser SSO session remains active.
