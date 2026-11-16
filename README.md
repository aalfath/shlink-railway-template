# Shlink on Railway

A Railway template for [Shlink](https://shlink.io), the self-hosted URL shortener with a REST API, visit tracking and QR codes, plus the official [Shlink Web Client](https://shlink.io/documentation/shlink-web-client/) to manage it.

## What it deploys

| Service | Source | Version |
|---|---|---|
| **Shlink** | `shlink/Dockerfile` (this repo) | `shlinkio/shlink:5.1.8` pinned by digest |
| **Shlink Web Client** | `web-client/Dockerfile` (this repo) | `shlinkio/shlink-web-client:4.9.0` pinned by digest |
| **Postgres** | Railway Postgres | Railway's default |

- **Shlink** serves the short links and the REST API on its public Railway domain. It stores everything in Postgres, runs the database migrations on every start, and creates an API key from `INITIAL_API_KEY` on its first start. Health check: `/rest/health`.
- **Shlink Web Client** is preconfigured to talk to that Shlink server with that API key. Because the browser loads the key from `servers.json`, the whole web client sits behind HTTP basic auth (user `admin`, password generated at deploy). Health check: `/healthz` (no login).

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Shlink | `DEFAULT_DOMAIN` | `${{RAILWAY_PUBLIC_DOMAIN}}` | Domain used in generated short URLs. Change it when you add a custom domain. |
| Shlink | `INITIAL_API_KEY` | `${{secret(40,…)}}` | Admin API key, created on first start only. |
| Shlink | `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | references to `Postgres` | Don't change. |
| Shlink Web Client | `WEB_USERNAME` | `admin` | Basic-auth user. |
| Shlink Web Client | `WEB_PASSWORD` | `${{secret(24,…)}}` | Basic-auth password. The web client refuses to start if it is empty. |
| Shlink Web Client | `SHLINK_SERVER_URL`, `SHLINK_SERVER_API_KEY` | references to `Shlink` | Don't change. |

Fixed settings (`DB_DRIVER=postgres`, `IS_HTTPS_ENABLED=true`) are baked into `shlink/Dockerfile`. Any other [Shlink environment variable](https://shlink.io/documentation/environment-variables/) can be added to the Shlink service, for example `GEOLITE_LICENSE_KEY` for visit geolocation or `DEFAULT_BASE_URL_REDIRECT`.

## Using it

1. Open the **Shlink Web Client** domain and log in as `admin` with the `WEB_PASSWORD` value from the service's Variables tab.
2. Create short links. They are served from the **Shlink** domain.
3. To use the API or the `shlink` CLI elsewhere, send the `INITIAL_API_KEY` value as the `X-Api-Key` header.

## How updates reach you

Both app services build from this repo's `main` branch. When a new Shlink or web-client release is pinned here, Railway shows an "update available" notice on your project and you choose when to apply it. Read `CHANGELOG.md` first: breaking changes are listed at the top of each entry. Your data stays in Postgres; Shlink migrates the schema on start.

## Local test

`compose.test.yml` builds both images with a local Postgres:

```sh
KEY=$(head -c 30 /dev/urandom | base64 | tr -dc A-Za-z0-9) PW=change-me docker compose -f compose.test.yml up --build
```
