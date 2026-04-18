## ADDED Requirements

### Requirement: Retired demos are not exposed from app entry points
The system SHALL expose only supported demo destinations from the main app shell and MUST remove retired demo pages from reachable navigation.

#### Scenario: Swipe demo action is removed from the main loader screen
- **WHEN** the user opens the lorem loader screen
- **THEN** the app MUST NOT show an action that opens the swipe demo page

#### Scenario: Swipe demo code is no longer part of active navigation
- **WHEN** the app is built after this change
- **THEN** no active app screen or route wiring MUST reference the swipe demo page

### Requirement: Removing a retired demo does not change supported demos
The system SHALL preserve remaining supported demo screens when a retired demo is removed.

#### Scenario: Screening workspace remains available
- **WHEN** the user opens the lorem loader screen after the swipe demo is removed
- **THEN** the screening workspace entry point MUST still be available
