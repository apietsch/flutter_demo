# keycloak-config-cli (Proxmox Keycloak)

This setup applies Keycloak realm/client config to a remote Keycloak instance (e.g. your Proxmox host) using `keycloak-config-cli`.

## Source of Truth
Configuration files are read from:

- `infra/keycloak/realm/`

Currently this includes:

- `infra/keycloak/realm/flutter-demo-realm.json`

## 1) Prepare environment

From repo root:

```bash
cp infra/keycloak-config-cli/.env.example infra/keycloak-config-cli/.env
```

Edit `infra/keycloak-config-cli/.env` and set:

- `KEYCLOAK_URL` (your Proxmox Keycloak base URL)
- `KEYCLOAK_USER`
- `KEYCLOAK_PASSWORD`

## 2) Apply config

```bash
docker compose \
  --env-file infra/keycloak-config-cli/.env \
  -f infra/keycloak-config-cli/docker-compose.yml \
  run --rm keycloak-config-cli
```

## 3) Optional dry run style checks

Use stricter validation and debug logging in `.env`:

- `IMPORT_VALIDATE=true`
- `LOGGING_LEVEL_ROOT=DEBUG`

Then rerun the same command.

## Notes

- Keep credentials out of git (`.env` is local only).
- This is designed to be idempotent and repeatable.
- If your Keycloak is behind reverse proxy/TLS, set `KEYCLOAK_URL` accordingly.

## Typical workflow

1. Edit realm config in `infra/keycloak/realm/*.json`
2. Run config-cli apply command
3. Verify changes in Keycloak admin UI or via Admin API

