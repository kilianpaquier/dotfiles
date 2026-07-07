---
applyTo: "**/Makefile,**/*.mk"
description: Makefile conventions
globs: ["**/Makefile", "**/*.mk"]
paths: ["**/Makefile", "**/*.mk"]
---
# Makefile

## Targets

- Declare `.PHONY` right before every non-file target.
- Prefix every command `@` — suppress echo.
- Target names: `kebab-case`.
- List prereqs after `:` (e.g., `dev: build`).

## Variables

- Name: `SCREAMING_SNAKE_CASE`.
- Use `?=` optional defaults.
- Align values with spaces, multiple vars same block.
- Use `$(ARGS)` forward extra args to commands.
