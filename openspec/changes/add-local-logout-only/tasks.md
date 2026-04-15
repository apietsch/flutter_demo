## 1. Logout Behavior

- [ ] 1.1 Add local-only logout config flag with default enabled.
- [ ] 1.2 Update auth service sign-out path to skip end-session in local-only mode.

## 2. Documentation

- [ ] 2.1 Document local-only logout behavior and SSO tradeoff.
- [ ] 2.2 Document override path for environments requiring end-session logout.

## 3. Verification

- [ ] 3.1 Validate iOS logout no longer triggers web-auth popup.
- [ ] 3.2 Run analyze/tests and basic native auth smoke checks.
