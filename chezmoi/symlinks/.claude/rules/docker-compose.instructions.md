---
applyTo: "**/{docker-compose,compose}.{yml,yaml},**/{docker-compose,compose}.*.{yml,yaml}"
description: Docker Compose conventions
globs: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
paths: ["**/{docker-compose,compose}.{yml,yaml}", "**/{docker-compose,compose}.*.{yml,yaml}"]
---

# Docker Compose

## File

- Prefer `docker-compose.yml` as the filename; `compose.yml` is also acceptable.
- Do not include a `version:` field (removed in Compose v2).

## Services

Order service keys as follows (omit keys that are not needed):

1. `build` / `image`
2. `container_name`
3. `restart`
4. `environment`
5. `volumes`
6. `ports`
7. `depends_on`
8. `healthcheck`

## Images

- Never use `:latest`. Always pin image tags to an explicit version (e.g. `postgres:16`).

## Restart policy

- Use `restart: unless-stopped` for long-running services.
- Use `restart: on-failure` for one-shot or migration containers.

## Environment variables

- Use map syntax for `environment:`:

  ```yaml
  environment:
    POSTGRES_PASSWORD: secret
    POSTGRES_USER: app
  ```

## depends_on

- Define a `healthcheck:` block on a service when it doesn't provide a native `HEALTHCHECK` instruction but a dependent service needs `condition: service_healthy`.
- Use `condition: service_healthy` when the service has a health check defined (native or compose-level); fall back to `condition: service_started` otherwise:

  ```yaml
  depends_on:
    db:
      condition: service_healthy
  ```

## Volumes

- Use named volumes (declared in the top-level `volumes:` block) for persistent data.
- Use bind mounts for development source files.
