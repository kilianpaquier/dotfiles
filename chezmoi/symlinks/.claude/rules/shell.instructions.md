---
applyTo: "**/*.sh,**/*.bash,**/*.zsh"
description: Shell script conventions
globs: ["**/*.sh", "**/*.bash", "**/*.zsh"]
paths: ["**/*.sh", "**/*.bash", "**/*.zsh"]
---

# Shell

## Shebang & portability

- Default to `#!/bin/sh` (POSIX). Use `#!/bin/bash` or `#!/bin/zsh` only when the script requires features absent from POSIX sh.
- In POSIX sh: `[ ]` for tests, `$()` for substitution, no `local`, no `[[ ]]`, no `((...))`.

## Error handling

For bash scripts, add at the top:
```sh
set -euo pipefail
```

For POSIX scripts, add at the top:
```sh
set -e
```

## Style

- Early exit from a function with `return <code>`; early exit from a script with `exit <code>`. Use non-zero codes to signal failure.
- Function names: `snake_case()`. No `function` keyword.
- Run shellcheck on every script; fix all warnings before finishing.
- Quote variables when shellcheck requires it.
- Suppress a warning only with a targeted directive: `# shellcheck disable=SCxxxx`. Never use bare `# shellcheck disable`.
