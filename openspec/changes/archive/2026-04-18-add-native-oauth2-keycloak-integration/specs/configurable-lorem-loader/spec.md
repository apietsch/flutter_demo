## MODIFIED Requirements

### Requirement: User can load text from a configurable URL
The system SHALL allow the user to provide an absolute URL and load text content from it, but only when authenticated.

#### Scenario: Authenticated load succeeds
- **WHEN** an authenticated user enters a valid absolute URL and presses Load
- **THEN** the system MUST request content from that URL
- **AND** the response body MUST be shown in a scrollable text area on success

#### Scenario: Unauthenticated user attempts to load
- **WHEN** the user is logged out
- **THEN** the Load action MUST be disabled
- **AND** the UI MUST indicate that sign-in is required before loading content
