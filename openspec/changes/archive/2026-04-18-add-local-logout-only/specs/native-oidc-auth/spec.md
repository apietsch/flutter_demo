## MODIFIED Requirements

### Requirement: Native logout clears app auth state
The system SHALL clear local auth state on logout, and by default perform local-only logout to avoid external browser prompts.

#### Scenario: Default logout behavior
- **WHEN** user selects logout in default configuration
- **THEN** local auth state MUST be cleared immediately
- **AND** no iOS sign-in popup caused by end-session flow should appear
