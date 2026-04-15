## Context

The current app wires a native-first OIDC implementation (`flutter_appauth`) directly in app startup. This works for iOS/macOS but does not provide a dependable browser-native auth flow for Flutter Web. The project already has stable auth state abstractions (`AuthService`, `AuthSession`, `AuthController`) and existing Keycloak setup docs, so the change should preserve these contracts while adding a web-specific adapter.

Constraints:
- Native login/logout behavior must remain stable.
- Web flow must follow OAuth2/OIDC Authorization Code + PKCE.
- Keycloak redirect/origin settings differ between native and web.

Stakeholders:
- App developers shipping across iOS/macOS/web.
- Keycloak administrators maintaining client config.

## Goals / Non-Goals

**Goals:**
- Add reliable Keycloak login/logout for Flutter Web.
- Keep a single app-level auth contract while selecting implementation by platform.
- Define secure, explicit web token persistence and refresh behavior.
- Document Keycloak web client setup for dev and production.

**Non-Goals:**
- Implement Windows desktop auth in this change.
- Replace the existing native auth provider.
- Introduce multi-tenant realm switching.

## Decisions

1. Decision: Introduce platform auth adapter selection behind `AuthService`.
- Rationale: preserves UI/controller contracts and limits risk to bootstrap wiring.
- Alternative considered: fork controller/UI paths for web and native.
- Why not chosen: duplicates logic and increases regression surface.

2. Decision: Use browser-native Authorization Code + PKCE for web.
- Rationale: standards-compliant web OIDC flow compatible with Keycloak.
- Alternative considered: keep relying on native-style plugin behavior on web.
- Why not chosen: not reliable for browser runtime and callback semantics.

3. Decision: Keep native and web callback configuration separate.
- Rationale: native custom scheme and web HTTPS redirects have different constraints.
- Alternative considered: single shared redirect URI variable.
- Why not chosen: creates fragile config and environment confusion.

4. Decision: Recommend separate Keycloak clients for native and web (optional but preferred).
- Rationale: cleaner security policy and origin/redirect isolation.
- Alternative considered: one shared client for all platforms.
- Why not chosen: possible, but harder to operate securely over time.

5. Decision: Define explicit web session persistence policy (session-first default).
- Rationale: lower risk for token exposure in browser storage.
- Alternative considered: long-lived local persistence by default.
- Why not chosen: increases theft/replay exposure on shared machines.

## Risks / Trade-offs

- [Risk] Keycloak CORS/origin misconfiguration causes token exchange failures.
  - Mitigation: include strict web redirect/origin checklist in docs and smoke test steps.

- [Risk] Platform branching introduces startup wiring regressions.
  - Mitigation: keep branch only at composition root and reuse existing controller/state.

- [Risk] Web persistence policy may reduce "remembered login" convenience.
  - Mitigation: make policy configurable and document security/UX tradeoff.

- [Risk] Native behavior regresses while touching shared auth abstractions.
  - Mitigation: preserve native adapter contract and add regression smoke tests for iOS/macOS.

## Migration Plan

1. Add web auth adapter and platform selection in bootstrap wiring.
2. Add Keycloak web redirect/origin configuration in environment docs.
3. Implement web callback handling and token lifecycle support.
4. Verify native login unchanged.
5. Rollout with web smoke tests first in dev, then production domain.

Rollback strategy:
- Disable web adapter selection and fall back to current native-only behavior for non-web targets.
- Keep native flow unaffected throughout rollback.

## Open Questions

- Should web and native use separate Keycloak clients by default in this repo examples?
- Which web persistence mode should be default: in-memory/session storage/local storage?
- Do we need silent refresh support immediately, or only refresh-on-action initially?
