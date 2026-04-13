# Local Keycloak (Flutter Demo)

## Start
From repository root:

```bash
docker compose -f infra/keycloak/docker-compose.yml up -d
```

## Stop

```bash
docker compose -f infra/keycloak/docker-compose.yml down
```

## Admin Console
- URL: http://localhost:8080
- Admin user: `admin`
- Admin password: `admin`

## Preloaded Realm
- Realm: `flutter-demo`
- Client ID: `flutter-app` (public OIDC client, PKCE enabled)
- Demo user:
  - Username: `demo`
  - Password: `demo123`

## Notes for Flutter OAuth2
Use these base values later in the app integration:
- Authority: `http://localhost:8080/realms/flutter-demo`
- Authorization endpoint: `http://localhost:8080/realms/flutter-demo/protocol/openid-connect/auth`
- Token endpoint: `http://localhost:8080/realms/flutter-demo/protocol/openid-connect/token`
- End session endpoint: `http://localhost:8080/realms/flutter-demo/protocol/openid-connect/logout`
- Client ID: `flutter-app`

For iOS simulator, `localhost` usually works when browser-based auth runs on host loopback. If needed, we can also add explicit host aliases or additional redirect URIs.
