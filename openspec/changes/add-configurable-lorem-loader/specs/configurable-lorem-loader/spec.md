## ADDED Requirements

### Requirement: User can load text from a configurable URL
The system SHALL allow the user to provide an absolute URL and load text content from it.

#### Scenario: Valid URL load succeeds
- **WHEN** the user enters a valid absolute URL and presses Load
- **THEN** the system MUST request content from that URL
- **AND** the response body MUST be shown in a scrollable text area on success

### Requirement: Loader shows explicit runtime states
The system SHALL provide clear loading and outcome states during fetch operations.

#### Scenario: Loading in progress
- **WHEN** a fetch request is active
- **THEN** the system MUST show a loading indicator
- **AND** disable duplicate load interactions

#### Scenario: Request fails
- **WHEN** URL validation fails, timeout occurs, or server response is non-success
- **THEN** the system MUST show a user-readable error message

### Requirement: URL validation prevents invalid requests
The system SHALL reject malformed or non-absolute URLs before performing network calls.

#### Scenario: Invalid URL entered
- **WHEN** the user provides an invalid URL
- **THEN** the system MUST not send an HTTP request
- **AND** show a validation error
