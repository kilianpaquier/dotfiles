---
applyTo: "**/Dockerfile,**/Dockerfile.*"
description: Dockerfile conventions
globs: ["**/Dockerfile", "**/Dockerfile.*"]
paths: ["**/Dockerfile", "**/Dockerfile.*"]
---

# Dockerfile

## Stages

- Always use multi-stage builds.
- Label each stage with a comment banner and a named `AS <stage>`:

  ```dockerfile
  #############################
  #        STAGE BUILD        #
  #############################
  FROM golang:1.23 AS build
  ```

- Build stage: use the language-specific image.
- Run stage: prefer the smallest viable image in this order:
  1. `scratch` - for fully static binaries that make no system calls requiring shared libraries or CA certificates.
  2. `gcr.io/distroless/static-debian12:nonroot` - when CA certificates or a minimal libc are needed (e.g. a static binary that makes HTTPS calls).
  3. `alpine` - as a fallback when a runtime environment is required (e.g. JRE for Java).

## Instructions

- Set `WORKDIR /app` in every stage.
- Declare `ARG` before the first instruction that uses it.
- Chain `RUN` commands with `&&` and `\` rather than multiple `RUN` layers.
- Multi-file `COPY` statements: one path per line with `\` continuation.
- Use JSON array syntax for `ENTRYPOINT`: `ENTRYPOINT [ "/app/binary" ]`.
- Prefer `ENTRYPOINT` over `CMD` for binaries.

## Labels

Use OCI image spec labels. Group `authors`/`vendor` together, then the rest alphabetically:

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

Standard build args to declare in the build stage:

```dockerfile
ARG GIT_COMMIT
ARG GIT_REF_NAME
ARG VERSION=v0.0.0
```

For Go projects, also declare `ARG CGO_ENABLED=0` in the build stage.
