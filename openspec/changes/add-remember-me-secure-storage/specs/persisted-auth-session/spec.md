## ADDED Requirements

### Requirement: Auth session is persisted securely
The system SHALL store auth session information in secure platform storage when available.

#### Scenario: Session persisted after successful login
- **WHEN** sign-in completes successfully
- **THEN** the system MUST persist session data required for restore/refresh

### Requirement: Session is restored at app startup
The system SHALL attempt to restore persisted auth state when the app initializes.

#### Scenario: Valid stored session exists
- **WHEN** app starts and persisted session is valid
- **THEN** the system MUST initialize auth state as authenticated

#### Scenario: Stored session payload is invalid
- **WHEN** stored session data cannot be decoded/validated
- **THEN** the system MUST clear persisted state
- **AND** continue in logged-out state

### Requirement: Refresh lifecycle handles expiry transitions
The system SHALL refresh session tokens when needed and clear state on unrecoverable refresh failures.

#### Scenario: Refresh succeeds
- **WHEN** token is near expiry and refresh token is valid
- **THEN** the system MUST refresh and persist updated session metadata

#### Scenario: Refresh fails permanently
- **WHEN** refresh request fails with unrecoverable error
- **THEN** the system MUST clear local session and require sign-in
