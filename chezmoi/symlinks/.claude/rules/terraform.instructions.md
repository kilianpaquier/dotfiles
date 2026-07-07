---
applyTo: "**/*.tf,**/*.tofu,**/*.tfvars"
description: Terraform / OpenTofu conventions
globs: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
paths: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
---
# Terraform / OpenTofu

## Module file layout

Standard files per module: `versions.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
Add `data_and_locals.tf` (not `locals.tf`) only when many data sources or locals - else keep in `main.tf`.
Add `imports.tf` for Terraform import blocks.

## Naming

- Single resource of its type in module: use `"default"` as resource label.
- Variables, locals, outputs: `snake_case`.

## Block ordering

- `for_each` / `count` first in resource, module blocks.
- `source` first in module blocks.
- Remaining args alphabetically.

## Provider blocks

- Add registry doc URL as comment above each `provider` block.

## Variables & outputs

- Every `variable` needs `type`, `description`.
- Every `output` needs `description`.
- Field order in `variable`: `type`, `default`, `description` (then optional: `nullable`, `sensitive`, `validation`).
- No hardcoded values belonging in variables (account IDs, regions, CIDR blocks, domain names).
- Mark sensitive inputs `sensitive = true`.
