# chezmoi

chezmoi repo hold dotfiles (symlink or raw file), scripts, other elements from [**chezmoi**](https://www.chezmoi.io/).

Purpose: share computer setup via automation + shared config.

## Specificities

- Use `chezmoi` subfolder for chezmoi elements (per `.chezmoiroot` config)
- Update `README.md` prompts table when add new init prompt in `.chezmoi.yaml.tmpl`
- Update `README.md` tooling table and `.chezmoidata/tools.yaml` when add a new tool
- Update `.ps1` + `.sh` equivalent scripts when add new script element
- Never use `chezmoi` CLI, skip trivial verification of prompts, scripts, etc.

## Agent runtimes permissions

- Trusted directories between the following files must be identical, always update them together:
  - `dot_claude/settings.partial.json`: `permissions.additionalDirectories`
  - `dot_copilot/modify_private_config.json.tmpl`: `trustedFolders`
- URLs permissions between the following files must be identical, always update them together:
  - `dot_claude/settings.partial.json`: `WebFetch(domain:...)`,
  - `dot_copilot/settings.partial.json`: `allowedUrls`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.urls.autoApprove`
- Tools permissions between the following files must be identical, always update them together:
  - `dot_claude/settings.partial.json`: `permissions.allow`, `permissions.ask`, `permissions.deny`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.terminal.autoApprove`

## Third-party

- `Context7` library ID for chezmoi docs: `/websites/chezmoi_io`.

## Verification

- Never run `chezmoi` unless explicitely asked.

---

@README.md
