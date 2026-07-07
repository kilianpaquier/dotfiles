---
applyTo: "**/Dockerfile,**/Dockerfile.*"
description: Dockerfile conventions
globs: ["**/Dockerfile", "**/Dockerfile.*"]
paths: ["**/Dockerfile", "**/Dockerfile.*"]
---
# Dockerfile

## Stages

- Always multi-stage builds.
- Label each stage: comment banner + named `AS <stage>`:

```dockerfile
#############################
#        STAGE BUILD        #
#############################
FROM golang:1.23 AS build
```

- Build stage: language-specific image.
- Run stage: smallest viable image, in order:
  1. `scratch` - fully static binaries, no syscalls needing shared libs or CA certs.
  2. `gcr.io/distroless/static-debian12:nonroot` - CA certs or minimal libc needed (e.g. static binary makes HTTPS calls).
  3. `alpine` - fallback when runtime env needed (e.g. JRE for Java).

## Instructions

- Set `WORKDIR /app` every stage.
- Declare `ARG` before first instruction using it.
- Chain `RUN` commands with `&&` and `\`, not multiple `RUN` layers.
- Multi-file `COPY`: one path per line, `\` continuation.
- JSON array syntax for `ENTRYPOINT`: `ENTRYPOINT [ "/app/binary" ]`.
- Prefer `ENTRYPOINT` over `CMD` for binaries.

## Labels

Use OCI image spec labels. Group `authors`/`vendor` together, rest alphabetical:

```dockerfile
LABEL org.opencontainers.image.authors="name <email>"
LABEL org.opencontainers.image.vendor="name"

LABEL org.opencontainers.image.description="..."
LABEL org.opencontainers.image.documentation="..."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="..."
LABEL org.opencontainers.image.title="..."
LABEL org.opencontainers.image.url="..."
```

## Build args

Standard build args, declare in build stage:

```dockerfile
ARG GIT_COMMIT
ARG GIT_REF_NAME
ARG VERSION=v0.0.0
```

Go projects: also declare `ARG CGO_ENABLED=0` in build stage.
