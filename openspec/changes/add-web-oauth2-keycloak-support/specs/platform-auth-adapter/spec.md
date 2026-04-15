## ADDED Requirements

### Requirement: Auth service selection is platform-aware
The system MUST select an auth adapter by runtime platform while exposing a shared app-level auth contract.

#### Scenario: App starts on web
- **WHEN** the app initializes in a browser runtime
- **THEN** the system MUST instantiate the web auth adapter
- **AND** the app MUST not depend on native-only auth plugin behavior for web login

#### Scenario: App starts on native
- **WHEN** the app initializes on iOS or macOS
- **THEN** the system MUST instantiate the existing native auth adapter
- **AND** native login/logout behavior MUST remain backward-compatible

### Requirement: Shared auth controller contract remains stable
The system MUST preserve the controller/session contract used by feature UI regardless of platform adapter.

#### Scenario: Auth state consumed by feature pages
- **WHEN** UI components read auth state or trigger sign-in/sign-out
- **THEN** behavior MUST use the same `AuthController` interface across platforms
- **AND** platform differences MUST be hidden behind adapter implementations

### Requirement: Platform-specific auth config is explicit
The system MUST support explicit platform-appropriate auth configuration values.

#### Scenario: Web and native redirect configuration
- **WHEN** auth config is provided for both web and native environments
- **THEN** native custom-scheme redirect settings and web HTTPS redirect settings MUST be independently configurable
- **AND** misconfiguration MUST be detectable via documented validation checks
