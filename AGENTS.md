# chezmoi

Dotfiles managed by [chezmoi](https://www.chezmoi.io/), with Linux packages installed by home-manager (nix).
The source root is `chezmoi/`, set in `.chezmoiroot`.
Paths below are relative to it, except `symlinks/` and repo-root files.

## Before changing anything

- Check the upstream standard first (man pages, official docs, Context7 `/websites/chezmoi_io` for chezmoi), and follow the mechanism it documents.
- Check how sibling files already solve the same problem (checks, warnings, layout), and match them.
- Propose a workaround only when neither gives an answer, and say so.

## Where things go

- Linux packages go in `private_dot_config/home-manager/home.nix.tmpl`, with attrs from `nixpkgs-unstable` only.

### Removing paths

The right file depends on whether chezmoi ever managed the path.

- Paths chezmoi never managed (caches, tool state) go in `.chezmoiremove.tmpl`.
- Paths chezmoi managed until an option got deselected go in `.chezmoitemplates/chezmoiignore.tmpl`.
- The `run_onchange_after_60-prune-deselected.sh.tmpl` script deletes those when the selection changes.
- Paths that never apply to an OS go in `.chezmoiignore.tmpl` itself, where nothing prunes them.

## Scripts

- Add a date stamp comment only when upstream drifts on its own (mise tools, agent plugins, winget).
- A script depending on a file outside its body puts that file's `sha256sum` in a comment, so `run_onchange_` sees changes.

### Fragments

Embedding a fragment from `.chezmoitemplates/<os>/` keeps it inside the script, so `run_onchange_` tracks it and `diff.scriptContents: false` keeps it out of `chezmoi diff`.

- Embed a static fragment with `{{ include ".chezmoitemplates/<os>/<name>" | trim }}`.
- Embed a fragment that reads chezmoi data with `{{ includeTemplate "<os>/<name>" . | trim }}`.
- A fragment runs in the parent's shell with the parent's options, so it has no shebang and no `set`.
- Guard a fragment's body with `if` where an `exit` would end the parent.
- Add the `.tmpl` suffix only when the template syntax breaks shellcheck.

## Agents

- Cover every runtime the `ai.runtimes` prompt offers, checking an unselected one's docs online.
- Set an unselected plugin to `false` in `.chezmoitemplates/plugins.json.tmpl`, since the sync uninstalls `false` entries and leaves deleted ones installed.

### sbx

The entry point is `~/.sbxenv.yaml` (`dot_sbxenv.yaml.tmpl`), started with `sbx env run`.
It mounts the host harness read-only.
It composes `dot_sbx/kits/<agent>.yaml` with `dot_sbx/kits/tools.yaml`.

- Kits follow Sandbox Kit v3 as the latest sbx release implements it, not the nix-installed version.
- Tokens reach the sandbox only through `sbx secret` and the proxy, never as a credential file or the mise secrets file.
- Declare a credential service in a kit only when the agent's published kit lacks it (`sbx kit inspect docker.io/sbx/<agent>:latest`), since two owners of one service conflict.

## Keep in sync

- A new prompt in `.chezmoi.yaml.tmpl`: the README prompts tables.
- A new mise bundle:
  - `.chezmoidata/tools.yaml`
  - the `$bundles` dict in `private_dot_config/mise/modify_config.toml.py.tmpl`
  - the README tools table
  - its caches in `.chezmoiremove.tmpl`, its managed config in `.chezmoitemplates/chezmoiignore.tmpl`
- A new agent plugin: `.chezmoitemplates/plugins.json.tmpl` and the README agent components table.
- A desktop app in `home.nix.tmpl`: its counterpart in `.chezmoitemplates/windows/winget-sync.ps1` and the README desktop apps table.
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

## README

The [README.md](README.md) explains the setup to its users, with tables for prompts, tool bundles, desktop apps and agent components.
Read it when a task touches one of those.
Write in it only what a user sees or does, leaving mechanisms, config internals and binary names out.

## Checks and boundaries

- Run `shellcheck` on each changed shell script without the `.tmpl` suffix.
- Read-only chezmoi commands are fine: `cat`, `data`, `diff`, `ignored`, `managed`.
- Every chezmoi command runs `scripts/bootstrap.sh` first (`read-source-state` hook), which installs nix on a machine without it, so it exits fast once its work is done.
- Its GC-rooted env at `~/.local/state/chezmoi/env` lets `modify_*.py.tmpl` render on a fresh machine.
- Run `apply`, `init`, `update`, `execute-template` or any other state-changing command only when asked.
