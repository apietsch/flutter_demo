## ADDED Requirements

### Requirement: Logout clears local auth state without browser flow by default
The system SHALL perform local session clear on logout without invoking OIDC end-session when local-only mode is enabled.

#### Scenario: Local-only mode enabled
- **WHEN** authenticated user selects logout
- **THEN** runtime auth state and persisted session MUST be cleared
- **AND** no browser-based end-session flow MUST be started

### Requirement: Logout mode is configurable
The system SHALL allow disabling local-only mode to restore end-session behavior when required.

#### Scenario: Local-only mode disabled
- **WHEN** authenticated user selects logout and local-only mode is off
- **THEN** system MAY invoke configured end-session flow
