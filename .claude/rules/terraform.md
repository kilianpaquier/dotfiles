---
applyTo: "**/*.tf,**/*.tofu,**/*.tfvars"
description: Terraform / OpenTofu conventions
globs: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
paths: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
---

# Terraform / OpenTofu

## Module file layout

Standard files per module: `versions.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
Add `data_and_locals.tf` (not `locals.tf`) only when there are many data sources or locals - otherwise keep them in `main.tf`.
Add `imports.tf` for Terraform import blocks.

## Naming

- Single resource of its type in a module: use `"default"` as the resource label.
- Variables, locals, outputs: `snake_case`.

## Block ordering

- `for_each` / `count` first in resource and module blocks.
- `source` first in module blocks.
- Remaining arguments alphabetically.

## Provider blocks

- Add the registry documentation URL as a comment above each `provider` block.

## Variables & outputs

- Every `variable` must have `type` and `description`.
- Every `output` must have `description`.
- Field order within `variable`: `type`, `default`, `description` (then optional: `nullable`, `sensitive`, `validation`).
- No hardcoded values that belong in variables (account IDs, regions, CIDR blocks, domain names).
- Mark sensitive inputs with `sensitive = true`.
