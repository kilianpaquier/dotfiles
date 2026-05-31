---
applyTo: "**/Makefile,**/*.mk"
description: Makefile conventions
globs: ["**/Makefile", "**/*.mk"]
paths: ["**/Makefile", "**/*.mk"]
---

# Makefile

## Targets

- Declare `.PHONY` immediately before every non-file target.
- Prefix every command with `@` to suppress echo.
- Target names: `kebab-case`.
- List prerequisites after `:` (e.g., `dev: build`).

## Variables

- Name: `SCREAMING_SNAKE_CASE`.
- Use `?=` for optional defaults.
- Align values with spaces when declaring multiple variables in the same block.
- Use `$(ARGS)` to forward extra arguments to commands.
