## ADDED Requirements

### Requirement: Native login uses Authorization Code with PKCE
The system SHALL authenticate iOS/macOS users against Keycloak using OAuth2/OIDC Authorization Code + PKCE.

#### Scenario: Successful native sign-in
- **WHEN** a logged-out user selects sign-in on iOS/macOS
- **THEN** the system MUST complete browser-based authorization and token exchange
- **AND** transition auth state to authenticated on success

### Requirement: Native logout clears app auth state
The system SHALL allow native users to sign out and return to logged-out state.

#### Scenario: User signs out
- **WHEN** an authenticated user selects logout
- **THEN** local auth state MUST be cleared
- **AND** UI MUST render logged-out controls

### Requirement: Auth errors are user-visible
The system SHALL expose native auth failures in the UI.

#### Scenario: Native auth request fails
- **WHEN** login or token exchange fails
- **THEN** user MUST remain logged out
- **AND** an authentication error message MUST be shown
