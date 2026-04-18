## ADDED Requirements

### Requirement: Screening workspace shows seeded papers for first-pass review
The system SHALL present a screening workspace with seeded paper items for first-pass include, exclude, and maybe decisions.

#### Scenario: User opens screening workspace
- **WHEN** the user navigates to the screening workspace
- **THEN** the system MUST show a list of seeded paper entries with title, author, journal, year, and current screening status

### Requirement: Screening workspace filters papers by decision status
The system SHALL allow the user to filter the visible paper list by screening status.

#### Scenario: User selects a status filter
- **WHEN** the user selects All Papers, Unscreened, Included, Excluded, or Maybe
- **THEN** the system MUST update the visible paper list to match that filter

### Requirement: Screening decisions update paper status in the workspace
The system SHALL let the user mark each paper as include, exclude, or maybe from the screening workspace.

#### Scenario: User marks a paper include or maybe
- **WHEN** the user selects Include or Maybe for a paper
- **THEN** the system MUST update that paper to the selected status
- **AND** clear any previous exclusion note for that paper

#### Scenario: User marks a paper exclude
- **WHEN** the user selects Exclude for a paper
- **THEN** the system MUST require an exclusion note before applying the excluded status

### Requirement: Exclusion note flow preserves cancel behavior
The system SHALL not change a paper to excluded if the exclusion-note flow is canceled.

#### Scenario: User cancels exclusion note dialog
- **WHEN** the user starts an exclude action and dismisses the note dialog without saving
- **THEN** the system MUST leave the paper's existing status unchanged
