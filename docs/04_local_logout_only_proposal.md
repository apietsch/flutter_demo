# Proposal: Local Logout Only (No iOS Popup)

## Problem
When the user taps logout, iOS shows a system dialog (`... Wants to Use 'localhost' to Sign In`) because app logout currently calls Keycloak end-session via browser auth flow.

## Goal
Remove the iOS popup on app logout by switching to local-only logout behavior.

## Scope
- Change app logout to clear local auth state and secure storage only.
- Do not open browser/session flow during logout.
- Keep login and refresh flows unchanged.

## Proposed Behavior
1. User taps `Sign out`.
2. App clears local session/tokens (`AuthController` + secure storage).
3. App returns to logged-out UI immediately.
4. No iOS web-auth prompt appears.

## Security/UX Tradeoff
- Benefit: no popup and smoother logout UX.
- Tradeoff: Keycloak server/browser SSO session remains active.
  - Next login may be silent/quick if server session is still valid.

## Technical Plan
1. Add logout mode flag in auth config:
   - `AUTH_LOCAL_LOGOUT_ONLY` (default `true`)
2. In `OidcAuthService.signOut(...)`:
   - If local-only mode is enabled, skip `endSession` call.
3. Keep controller flow unchanged:
   - `signOut()` still clears local session and storage.
4. Document behavior in context docs.

## Acceptance Criteria
- Tapping `Sign out` no longer triggers iOS sign-in domain popup.
- App shows logged-out state immediately.
- `flutter analyze` and `flutter test` pass.

