# CODEX Context Handoff

## Snapshot
- Repository: `flutter_demo`
- Branch: `main`
- Current HEAD: `ec3dd7d`
- Remote status: local `main` has unpushed Phase 3 Remember Me + secure-storage implementation changes
- Primary targets: iOS simulator, macOS desktop, Chrome web

## Commit Timeline (authoritative)
1. `a5020da` - Add `AGENTS.md` for Flutter demo workflow
2. `7fc4dbb` - Scaffold Flutter app project
3. `76571e5` - Add proposal for configurable lorem text loader
4. `372fc55` - Implement configurable lorem text loader feature
5. `f8663b6` - Add iOS swipe demo and enable macOS outbound networking
6. `6a5f83b` - Add Codex context handoff documentation
7. `2675787` - Add local Keycloak Docker setup and setup documentation
8. `a44614f` - Add OAuth2 Keycloak integration proposal
9. `7b85d65` - Implement OAuth2 Phase 1 with Keycloak login/logout
10. `0e3c3dd` - Add refresh-token handling with persisted auth session
11. `6a103da` - Rework docs for OAuth2 Phase 2 refresh-token delivery
12. `252dd17` - Show last token refresh time in auth panel
13. `ec3dd7d` - Rename proposal docs with ordered prefixes

## Implemented Features

### 1) Lorem loader + swipe demo
- URL-configurable text loading with loading/error/empty states
- Swipe demo page with dismissible cards and reset flow

Primary files:
- `lib/features/lorem/...`
- `lib/features/swipe/...`

### 2) OAuth2/OIDC login/logout (Phase 1)
- Keycloak sign-in via browser (Authorization Code + PKCE)
- Session state with login/logout UI
- Protected loader action gated by authentication

Primary files:
- `lib/features/auth/config/auth_config.dart`
- `lib/features/auth/data/auth_service.dart`
- `lib/features/auth/state/auth_controller.dart`
- `lib/features/auth/ui/login_panel.dart`
- `ios/Runner/Info.plist`
- `macos/Runner/Info.plist`

### 3) Refresh-token + persisted session (Phase 2)
- Secure persistence via `flutter_secure_storage`
- Restore session on app start
- Proactive refresh before expiry
- Refresh-on-demand before protected load action
- Clear local session on refresh failure

Primary files:
- `lib/features/auth/data/auth_session_store.dart`
- `lib/features/auth/data/auth_service.dart`
- `lib/features/auth/state/auth_controller.dart`
- `lib/features/lorem/ui/lorem_loader_page.dart`

### 4) Remember Me + storage policy alignment (Phase 3)
- Remember Me checkbox in auth UI
- Remember Me preference persisted and reused
- Auth sign-in request passes remember-me hint to Keycloak
- Storage policy aligns with Remember Me:
  - ON: session persisted across app restarts
  - OFF: session not persisted
- Keycloak realm remember-me session policies configured and documented

## Local Keycloak Setup
- Docker stack in `infra/keycloak`
- Realm: `flutter-demo`
- Client: `flutter-app` (public, PKCE)
- Demo user: `demo` / `demo123`
- OIDC discovery:
  - `http://localhost:8080/realms/flutter-demo/.well-known/openid-configuration`

Start/stop:
```bash
docker compose -f infra/keycloak/docker-compose.yml up -d
docker compose -f infra/keycloak/docker-compose.yml down
```

## Validation Baseline
- `flutter analyze`: passes
- `flutter test`: passes

## Documentation Map
- Keycloak + OAuth planning:
  - `docs/02_oauth2_keycloak_integration_proposal.md`
- Remember-me + secure storage planning:
  - `docs/03_remember_me_and_secure_storage_proposal.md`
- Local logout UX planning:
  - `docs/04_local_logout_only_proposal.md`
- Phase 1 delivery comparison:
  - `docs/oauth2_phase1_report.md`
- Phase 2 refresh-token delivery comparison:
  - `docs/oauth2_phase2_refresh_report.md`
- Phase 3 remember-me + secure storage delivery comparison:
  - `docs/oauth2_phase3_remember_me_report.md`
- Earlier lorem feature proposal:
  - `docs/01_lorem_loader_proposal.md`

## Known Operational Notes
- iOS simulator detection can intermittently fail; booting simulator explicitly resolves it.
- `flutter run -d ios` may not resolve target consistently; explicit simulator ID is reliable.
- macOS app requires `com.apple.security.network.client=true` entitlement (already applied).
- Local logout mode currently defaults to enabled (`AUTH_LOCAL_LOGOUT_ONLY=true`), so app logout clears local session only and does not call Keycloak end-session.

## Quick Reconstruction Prompt
"Read `AGENTS.md` and `docs/CODEX_CONTEXT.md` first. Use Keycloak from `infra/keycloak`. Preserve Phase 1 login/logout and Phase 2 refresh-token behavior. Validate with `flutter analyze` and `flutter test` before finalizing."
