## 1. Secure Session Persistence

- [ ] 1.1 Implement secure session store read/write/clear paths.
- [ ] 1.2 Integrate persist/restore calls into auth controller lifecycle.

## 2. Refresh and Failure Handling

- [ ] 2.1 Implement refresh-on-expiry behavior and scheduling.
- [ ] 2.2 Clear session on unrecoverable refresh failures.
- [ ] 2.3 Add corruption fallback behavior for invalid stored payloads.

## 3. Remember-Me Policy

- [ ] 3.1 Align Keycloak realm remember-me settings with expected UX.
- [ ] 3.2 Document effective timeouts and behavior boundaries.

## 4. Verification

- [ ] 4.1 Add/adjust tests for restore/refresh/logout persistence lifecycle.
- [ ] 4.2 Run analyze/tests and perform restart/long-idle smoke checks.
