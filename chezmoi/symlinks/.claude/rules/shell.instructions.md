---
applyTo: "**/*.sh,**/*.bash,**/*.zsh"
description: Shell script conventions
globs: ["**/*.sh", "**/*.bash", "**/*.zsh"]
paths: ["**/*.sh", "**/*.bash", "**/*.zsh"]
---
# Shell

## Shebang & portability

- Default `#!/bin/sh` (POSIX). Use `#!/bin/bash` or `#!/bin/zsh` only when script need feature absent POSIX sh.
- POSIX sh: `[ ]` tests, `$()` substitution, no `local`, no `[[ ]]`, no `((...))`.

## Error handling

Bash scripts, add top:
```sh
set -euo pipefail
```

POSIX scripts, add top:
```sh
set -e
```

## Style

- Early exit function: `return <code>`; early exit script: `exit <code>`. Non-zero codes signal failure.
- Function names: `snake_case()`. No `function` keyword.
- Run shellcheck every script; fix all warnings before finish.
- Quote variables when shellcheck require.
- Suppress warning only targeted directive: `# shellcheck disable=SCxxxx`. Never bare `# shellcheck disable`.
