## ADDED Requirements

### Requirement: Web login uses Authorization Code with PKCE
The system MUST authenticate Flutter Web users against Keycloak using a browser-native OAuth2/OIDC Authorization Code + PKCE flow.

#### Scenario: User starts web login
- **WHEN** an unauthenticated web user selects sign-in
- **THEN** the system MUST initiate an authorization request to Keycloak using PKCE parameters
- **AND** the browser MUST navigate to the Keycloak login page

#### Scenario: User returns from Keycloak callback
- **WHEN** Keycloak redirects the browser to the registered web callback URI with an authorization code
- **THEN** the system MUST validate callback parameters and exchange the code for tokens
- **AND** the user MUST transition to authenticated state when exchange succeeds

### Requirement: Web logout clears local session and ends IdP session
The system MUST support web logout that clears app session state and performs OIDC end-session behavior when configured.

#### Scenario: User logs out on web
- **WHEN** an authenticated web user selects logout
- **THEN** local auth session data MUST be cleared
- **AND** the system MUST redirect to Keycloak end-session endpoint when logout endpoint is configured

### Requirement: Web auth failures are surfaced with actionable errors
The system MUST expose web auth failures in a user-visible and diagnosable way.

#### Scenario: Token exchange fails
- **WHEN** code exchange fails due to network, CORS, or invalid callback state
- **THEN** the system MUST keep the user in logged-out state
- **AND** the UI MUST show an authentication error message

### Requirement: Web client configuration requirements are documented
The system MUST document required Keycloak web client settings for redirects and origins.

#### Scenario: Developer configures web login
- **WHEN** a developer follows setup documentation
- **THEN** required redirect URIs and allowed origins for dev and production MUST be listed
- **AND** documentation MUST include at least one verification step for callback/token flow
