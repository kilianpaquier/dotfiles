# chezmoi

Dotfiles managed by [chezmoi](https://www.chezmoi.io/), with Linux packages installed by home-manager (nix).
The source root is `chezmoi/`, set in `.chezmoiroot`.
Paths below are relative to it, except `symlinks/` and repo-root files.

The [README.md](README.md) explains the setup to users.
Read it when a task touches prompts, tool bundles, desktop apps or agent components, which it lists in tables.

## Where things go

- Linux packages go in `private_dot_config/home-manager/home.nix.tmpl`, with attrs from `nixpkgs-unstable` only.
- Dev tools go in a mise bundle, see [Keep in sync](#keep-in-sync).
- Shell rc files and `local.nix` live in `symlinks/` at the repo root, and chezmoi links them into `$HOME`.
- A config file that a tool also writes gets a `modify_*.py.tmpl` calling a merge script from `.chezmoitemplates/scripts/`.
- The values a `modify_` script enforces live in a `*.partial.json` next to it, or in a dict inside the script.
- A file only the user fills in (secrets, kube config) gets the `create_` prefix, so chezmoi never overwrites it.
- A target holding credentials or tokens gets the `private_` prefix.
- Remote archives (agent rules, zsh4humans) go in `.chezmoiexternals/`.
- Windows apps go in `.chezmoitemplates/windows/winget-sync.ps1`, other Windows setup in `.chezmoiscripts/windows/`.

## home-manager or chezmoi script

Nix home-manager owns a step that runs as the user, needs no prompt, and fits in the nix switch.
The chezmoi scripts own the rest: `sudo`, passphrase prompts, tools outside nix, and Windows.

Root-only steps (pcscd, rootless containers, server identity, `/etc/wsl.conf`) go in `.chezmoiscripts/linux/run_onchange_after_00-system-config.sh.tmpl`.

`scripts/bootstrap.sh` is the `read-source-state` pre hook.
It runs before every chezmoi command, so it must exit fast once its work is done.
It installs nix, home-manager and a GC-rooted env at `~/.local/state/chezmoi/env` (jq, python with tomlkit).
That env lets `modify_*.py.tmpl` render on a fresh machine.

## Removing paths

The right file depends on whether chezmoi ever managed the path.

- Paths chezmoi never managed (caches, tool state) go in `.chezmoiremove.tmpl`.
- Paths chezmoi managed until an option got deselected go in `.chezmoitemplates/chezmoiignore.tmpl`.
- `run_onchange_after_60-prune-deselected.sh.tmpl` deletes those when the selection changes.
- Paths that never apply to an OS go in `.chezmoiignore.tmpl` itself, and nothing prunes them.

## Scripts

- Name every script `run_onchange_after_<NN>-<name>`.
- Only `run_after_70-restrict-permissions.sh` runs on every apply, because tools loosen permissions whenever they write.
- Add a date stamp comment only when upstream drifts on its own (mise tools, agent plugins, winget).
- A script depending on a file outside its body puts that file's `sha256sum` in a comment, so `run_onchange_` sees changes.
- Start a script like its siblings: `#!/bin/sh`, `set -e`, then source `$HOME/.profile` and `scripts/log.sh`.

### Fragments

A block longer than a few lines moves to a fragment under `.chezmoitemplates/<os>/`.
Embedding keeps it inside the script, so `run_onchange_` tracks it and `diff.scriptContents: false` keeps it out of `chezmoi diff`.

- Embed a static fragment with `{{ include ".chezmoitemplates/<os>/<name>" | trim }}`.
- Embed a fragment that reads chezmoi data with `{{ includeTemplate "<os>/<name>" . | trim }}`.
- Skip the `template` action for fragments, as it can't be piped to `trim`.
- A fragment runs in the parent's shell with the parent's options, so it has no shebang and no `set`.
- Start a shell fragment with `# shellcheck shell=sh`.
- Add the `.tmpl` suffix only when the template syntax breaks shellcheck.
- Guard a fragment's body with `if` instead of calling `exit`, which would end the parent.
- `info`, `warn` and `error` come from `scripts/log.sh`, which the parent sources.

## Agent plugins

- `.chezmoitemplates/plugins.json.tmpl` lists every plugin with the condition that enables it.
- Set a dropped plugin to `false`, because the sync uninstalls `false` entries and leaves deleted ones installed.

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

## Checks

- Run `shellcheck` on each changed shell script without the `.tmpl` suffix.
- Render a changed template with `chezmoi execute-template < <file>`.
- Check a rendered shell template with `chezmoi execute-template < <file> | shellcheck -s sh -`.
- pre-commit (gitleaks, whitespace) runs on every commit and in CI.

## Boundaries

- Read-only chezmoi commands are fine: `cat`, `data`, `diff`, `execute-template`, `managed`.
- Every chezmoi command runs `scripts/bootstrap.sh` first, which installs nix on a machine without it.
- Never run `apply`, `init`, `update` or any other command that changes state, unless asked.

## References

- Context7 library ID for chezmoi docs: `/websites/chezmoi_io`.
