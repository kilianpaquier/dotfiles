# chezmoi

Dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). Source root is `chezmoi/` (`.chezmoiroot`).

## Layout

### Files removal

- Use `.chezmoiremove.tmpl` to remove paths not managed by chezmoi.
- Use `.chezmoitemplates/ignored.tmpl` to remove paths managed by chezmoi (cleanup glue under `.chezmoiscripts/run_onchange_after_95-cleanup.sh.tmpl`).

### Ansible integration

- Use `ansible/tasks` for Linux system setup (apt, desktop apps, containers, server).
- Use `.chezmoiscripts/*.ps1.tmpl` for Windows system setup (since **ansible** is not compatible with it).
- All properties under `data` from `chezmoi.yaml.tmpl` are loaded as machine facts within **ansible** (at runtime for drift detection).

## Keep in sync

- A new prompt in `.chezmoi.yaml.tmpl`: the `README.md` prompts tables.
- A new tool: `.chezmoidata/tools.yaml` and the `README.md` tools table.
- A linux task in `ansible/tasks/`: its windows `.ps1` counterpart.
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
