# chezmoi

Dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). Source root is `chezmoi/` (`.chezmoiroot`).

## Layout

### Files removal

- Use `.chezmoiremove.tmpl` to remove paths not managed by chezmoi.
- Use `.chezmoitemplates/chezmoiignore.tmpl` to remove paths managed by chezmoi (cleanup glue under `.chezmoiscripts/linux/run_onchange_after_60-prune-deselected.sh.tmpl`, which runs only when the selection changes).

### Home-manager integration

- Use `private_dot_config/home-manager/home.nix.tmpl` for Linux packages (CLI tools, desktop apps, containers, agent runtimes, mise). Every attr must exist in `nixpkgs-unstable`.
- home-manager owns a step that runs as the user, needs no prompt, and belongs to the nix switch. chezmoi scripts own the rest (`sudo`, passphrase prompts, tools outside nix, Windows).
- `scripts/bootstrap.sh` is the `read-source-state` pre hook: installs nix, home-manager and a GC-rooted env (`~/.local/state/chezmoi/env`: jq, python with tomlkit) so `modify_*.py.tmpl` render on a fresh machine.
- Root-only steps (pcscd, rootless containers, server hostname, timezone, `/etc/wsl.conf`) live in `.chezmoiscripts/linux/run_onchange_after_00-system-config.sh.tmpl` with `sudo`.
- Use `.chezmoiscripts/windows/` for Windows system setup (winget).

### Scripts

- Every chezmoi script is `run_onchange_after_`, with a date stamp only where upstream drifts.
- The only exception is `run_after_70-restrict-permissions.sh`. It runs last on every apply, because the permissions it restricts drift whenever a tool writes a file.
- A block longer than a few lines goes in a fragment under `.chezmoitemplates/<os>/`, embedded so `diff.scriptContents: false` hides it and `run_onchange_` tracks it.
- Embed a fragment raw: `{{ include ".chezmoitemplates/<os>/<name>" | trim }}`, or `{{ includeTemplate "<os>/<name>" . | trim }}` when it reads chezmoi data. The `template` action can't be piped, so `trim` needs `includeTemplate`.
- A fragment has no shebang and no `set`, it runs in the parent's shell and options. Start a shell fragment with `# shellcheck shell=sh`.
- Add the `.tmpl` suffix only when the template syntax breaks shellcheck.
- A fragment never calls `exit`, since that would end the parent. Guard its body with `if` instead.
- The parent sources `scripts/log.sh`, so a fragment can use `warn` and `info`.

## Keep in sync

- A new prompt in `.chezmoi.yaml.tmpl`: the `README.md` prompts tables.
- A new tool: `.chezmoidata/tools.yaml` and the `README.md` tools table.
- A desktop app in `private_dot_config/home-manager/home.nix.tmpl`: its windows counterpart in `.chezmoitemplates/windows/winget-sync.ps1` and the `README.md` desktop apps table.
- Trusted directories:
  - `private_dot_claude/settings.partial.json`: `permissions.additionalDirectories`
  - `private_dot_copilot/modify_private_config.json.py.tmpl`: `trustedFolders`
- URL permissions:
  - `private_dot_claude/settings.partial.json`: `WebFetch(domain:...)`
  - `private_dot_copilot/settings.partial.json`: `allowedUrls`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.urls.autoApprove`
- Tool permissions:
  - `private_dot_claude/settings.partial.json`: `permissions.allow`, `permissions.ask`, `permissions.deny`
  - `dot_vscode-server/data/Machine/settings.copilot.partial.json`: `chat.tools.terminal.autoApprove`

## Boundaries

- Never run `chezmoi` unless explicitly asked.

## References

- Context7 library ID for chezmoi docs: `/websites/chezmoi_io`.

---

@README.md
