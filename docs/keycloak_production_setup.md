# Keycloak Setup Guide (Proxmox + Nginx + Flutter)

## Target
Use Keycloak at:
- `https://keycloak.nginx.alex-pietsch.de`

Use realm/client for app auth:
- Realm: `flutter-demo`
- Client ID: `flutter-app`

## 1) Keycloak base config
On Keycloak host, configure `/opt/keycloak/conf/keycloak.conf` for reverse proxy + hostname.

Typical values:
```ini
http-enabled=true
http-port=8080
hostname=keycloak.nginx.alex-pietsch.de
hostname-strict=true
proxy-headers=xforwarded
```

Restart Keycloak after changes.

## 2) Prepare keycloak-config-cli
Files in repo:
- `infra/keycloak-config-cli/docker-compose.yml`
- `infra/keycloak-config-cli/.env.example`
- `infra/keycloak/realm/flutter-demo-realm.json`

Create env file:
```bash
cp infra/keycloak-config-cli/.env.example infra/keycloak-config-cli/.env
```

Edit `.env` with your admin credentials and URL.

## 3) Apply realm config
From repo root:
```bash
docker compose \
  --env-file infra/keycloak-config-cli/.env \
  -f infra/keycloak-config-cli/docker-compose.yml \
  run --rm keycloak-config-cli
```

## 4) Verify realm endpoints
Open:
- `https://keycloak.nginx.alex-pietsch.de/realms/flutter-demo/.well-known/openid-configuration`

Expected: JSON discovery document with `issuer`, `authorization_endpoint`, `token_endpoint`.

## 5) Verify critical realm/client settings
In `flutter-demo` realm:
- `rememberMe = true`
- access token lifespan short (currently 300s)
- remember-me session windows set (7d idle / 30d max)

For client `flutter-app`:
- public OIDC client with PKCE
- redirect URI includes:
  - `com.example.flutterDemo:/oauth2redirect`

## 6) Run Flutter app against this Keycloak
```bash
flutter run -d ios \
  --dart-define=AUTH_ISSUER=https://keycloak.nginx.alex-pietsch.de/realms/flutter-demo
```

## 7) Functional checks
1. Sign in works.
2. Protected action (`Load`) works after login.
3. Token refresh works (see `Last token refresh` in app UI).
4. Logout is local-only (no iOS web-auth popup).

## 8) `kcadm.sh` admin checks (on Keycloak host)
Run from:
```bash
cd /opt/keycloak/bin
```

Login:
```bash
./kcadm.sh config credentials \
  --server https://keycloak.nginx.alex-pietsch.de \
  --realm master \
  --user tmpadm \
  --password 'admin123'
```

Useful checks:
```bash
./kcadm.sh get users -r master -q username=tmpadm --fields id,username
./kcadm.sh get clients -r master -q clientId=master-realm --fields id,clientId
./kcadm.sh get clients/<MASTER_REALM_CLIENT_ID>/roles -r master --fields name
./kcadm.sh get roles -r master --fields name
./kcadm.sh get realms/flutter-demo -r master
```

Grant realm-management style roles for admin user:
```bash
./kcadm.sh add-roles \
  -r master \
  --uid <USER_ID> \
  --cid <MASTER_REALM_CLIENT_ID> \
  --rolename manage-realm \
  --rolename view-realm \
  --rolename query-realms \
  --rolename manage-users \
  --rolename view-users \
  --rolename query-users \
  --rolename manage-clients \
  --rolename view-clients \
  --rolename query-clients
```

Optional realm creation right:
```bash
./kcadm.sh add-roles -r master --uid <USER_ID> --rolename create-realm
```

## Notes
- Current app logout mode is local-only by default (`AUTH_LOCAL_LOGOUT_ONLY=true`).
- If needed, override via dart define:
  - `--dart-define=AUTH_LOCAL_LOGOUT_ONLY=false`
