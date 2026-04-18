## ADDED Requirements

### Requirement: Remember-me behavior aligns with Keycloak policy
The system SHALL support long-lived session behavior only within Keycloak-configured remember-me limits.

#### Scenario: Remember-me realm settings enabled
- **WHEN** Keycloak remember-me idle or max session settings are configured
- **THEN** authenticated users MAY remain signed in across extended idle windows according to server policy

### Requirement: Logout removes local remembered state
The system SHALL clear local session data on logout regardless of remember-me server status.

#### Scenario: User logs out after remembered session
- **WHEN** user selects logout
- **THEN** local persisted session and runtime state MUST be cleared
