# chezmoi

Dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). Source root is `chezmoi/` (`.chezmoiroot`).

## Layout

### Files removal

- Use `.chezmoiremove.tmpl` to remove paths not managed by chezmoi.
- Use `.chezmoitemplates/chezmoiignore.tmpl` to remove paths managed by chezmoi (cleanup glue under `.chezmoiscripts/run_onchange_after_60-cleanup.sh.tmpl`).

### Home-manager integration

- Use `dot_config/home-manager/home.nix.tmpl` for Linux packages (CLI tools, desktop apps, containers, agent runtimes, mise). Every attr must exist in `nixpkgs-unstable`.
- `scripts/bootstrap.sh` is the `read-source-state` pre hook: installs nix, home-manager and a GC-rooted env (`~/.local/state/chezmoi/env`: jq, python with tomlkit) so `modify_*.py.tmpl` render on a fresh machine.
- Root-only steps (pcscd, server hostname, timezone) live in `.chezmoiscripts/run_onchange_before_00-system.sh.tmpl` with `sudo`.
- Use `.chezmoiscripts/*.ps1.tmpl` for Windows system setup (winget).

## Keep in sync

- A new prompt in `.chezmoi.yaml.tmpl`: the `README.md` prompts tables.
- A new tool: `.chezmoidata/tools.yaml` and the `README.md` tools table.
- A desktop app in `dot_config/home-manager/home.nix.tmpl`: its windows counterpart in `run_after_10-desktop.ps1.tmpl` and the `README.md` desktop apps table.
- Trusted directories:
  - `dot_claude/settings.partial.json`: `permissions.additionalDirectories`
  - `dot_copilot/modify_private_config.json.tmpl`: `trustedFolders`
- URL permissions:
  - `dot_claude/settings.partial.json`: `WebFetch(domain:...)`
  - `dot_copilot/settings.partial.json`: `allowedUrls`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.urls.autoApprove`
- Tool permissions:
  - `dot_claude/settings.partial.json`: `permissions.allow`, `permissions.ask`, `permissions.deny`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.terminal.autoApprove`

## Boundaries

- Never run `chezmoi` unless explicitly asked.

## References

- Context7 library ID for chezmoi docs: `/websites/chezmoi_io`.

---

@README.md
