---
applyTo: "**/{docker-compose,compose}.{yml,yaml},**/{docker-compose,compose}.*.{yml,yaml}"
description: Docker Compose conventions
globs: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
paths: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
---
# Docker Compose

## File

- Prefer `docker-compose.yml` as filename; `compose.yml` also fine.
- Skip `version:` field (removed Compose v2).

## Services

Order service keys as follows (skip keys not needed):

1. `build` / `image`
2. `container_name`
3. `restart`
4. `environment`
5. `volumes`
6. `ports`
7. `depends_on`
8. `healthcheck`

## Images

- Never `:latest`. Always pin image tags to explicit version (e.g. `postgres:16`).

## Restart policy

- `restart: unless-stopped` for long-running services.
- `restart: on-failure` for one-shot or migration containers.

## Environment variables

- Map syntax for `environment:`:

```yaml
environment:
  POSTGRES_PASSWORD: secret
  POSTGRES_USER: app
```

## depends_on

- Define `healthcheck:` block on service when it lacks native `HEALTHCHECK` instruction but dependent service needs `condition: service_healthy`.
- Use `condition: service_healthy` when service has health check (native or compose-level); fall back `condition: service_started` otherwise:

```yaml
depends_on:
  db:
    condition: service_healthy
```

## Volumes

- Named volumes (top-level `volumes:` block) for persistent data.
- Bind mounts for dev source files.
