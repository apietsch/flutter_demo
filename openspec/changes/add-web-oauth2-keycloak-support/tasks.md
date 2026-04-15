## 1. Platform Auth Architecture

- [ ] 1.1 Add platform-based auth adapter selection at app bootstrap (`kIsWeb` vs native).
- [ ] 1.2 Keep existing native `flutter_appauth` adapter wiring for iOS/macOS unchanged.
- [ ] 1.3 Introduce a dedicated web auth service implementation behind the shared `AuthService` contract.

## 2. Web OAuth2/OIDC Flow

- [ ] 2.1 Implement web login using Authorization Code + PKCE redirect flow.
- [ ] 2.2 Implement callback parsing/validation and authorization code exchange for web.
- [ ] 2.3 Map successful web token responses into shared `AuthSession` state.
- [ ] 2.4 Implement web logout with local session clear and optional end-session redirect.

## 3. Session, Refresh, and Error Handling

- [ ] 3.1 Define and implement web token persistence policy (session-first default).
- [ ] 3.2 Implement web refresh token behavior aligned with existing controller lifecycle.
- [ ] 3.3 Add actionable user-facing errors for web auth/callback/token-exchange failures.

## 4. Keycloak and Configuration

- [ ] 4.1 Add explicit web auth configuration keys (redirect/logout redirect/origin assumptions).
- [ ] 4.2 Document required Keycloak web client setup (redirect URIs and allowed origins for dev/prod).
- [ ] 4.3 Validate web auth setup against localhost and one production-style domain example.

## 5. Verification and Regression Safety

- [ ] 5.1 Add/adjust tests for platform adapter selection and shared controller contract stability.
- [ ] 5.2 Execute smoke tests: Chrome login/logout success and native iOS/macOS login regression checks.
- [ ] 5.3 Run `flutter analyze` and test suite; document results in change notes.
