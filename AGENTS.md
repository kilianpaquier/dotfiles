# chezmoi

Dotfiles managed by [chezmoi](https://www.chezmoi.io/), with Linux packages installed by home-manager (nix).
The source root is `chezmoi/`, set in `.chezmoiroot`.
Paths below are relative to it, except `symlinks/` and repo-root files.

The [README.md](README.md) explains the setup to users.
Read it when a task touches prompts, tool bundles, desktop apps or agent components, which it lists in tables.

## Before changing anything

- Check the upstream standard first (man pages, official docs, Context7), and follow the mechanism it documents for the task.
- Check how sibling files already solve the same problem (checks, warnings, layout), and match them.
- Only propose a workaround when neither gives an answer, and say so.

## Where things go

- Linux packages go in `private_dot_config/home-manager/home.nix.tmpl`, with attrs from `nixpkgs-unstable` only.
- Dev tools go in a mise bundle, see [Keep in sync](#keep-in-sync).
- A config file that a tool also writes gets a `modify_*.py.tmpl` calling a merge script from `.chezmoitemplates/scripts/`.
- The values a `modify_` script enforces live in a `*.partial.json` next to it, or in a dict inside the script.

## home-manager or chezmoi script

Nix home-manager owns a step that runs as the user, needs no prompt, and fits in the nix switch.
The chezmoi scripts own the rest: `sudo`, passphrase prompts, tools outside nix, and Windows.

Two scripts sit outside that split, the root-only system setup and the bootstrap hook.

- Root-only steps go in `.chezmoiscripts/linux/run_onchange_after_00-system-config.sh.tmpl`.
- Install a system package there with `pkg_install`, never a direct `apt-get`.
- The `scripts/bootstrap.sh` script is the `read-source-state` pre hook, so it runs before every chezmoi command and must exit fast once its work is done.
- Its GC-rooted env at `~/.local/state/chezmoi/env` lets `modify_*.py.tmpl` render on a fresh machine.

## Removing paths

The right file depends on whether chezmoi ever managed the path.

- Paths chezmoi never managed (caches, tool state) go in `.chezmoiremove.tmpl`.
- Paths chezmoi managed until an option got deselected go in `.chezmoitemplates/chezmoiignore.tmpl`.
- `run_onchange_after_60-prune-deselected.sh.tmpl` deletes those when the selection changes.
- Paths that never apply to an OS go in `.chezmoiignore.tmpl` itself, and nothing prunes them.

## Scripts

- Add a date stamp comment only when upstream drifts on its own (mise tools, agent plugins, winget).
- A script depending on a file outside its body puts that file's `sha256sum` in a comment, so `run_onchange_` sees changes.

### Fragments

A block longer than a few lines moves to a fragment under `.chezmoitemplates/<os>/`.
Embedding keeps it inside the script, so `run_onchange_` tracks it and `diff.scriptContents: false` keeps it out of `chezmoi diff`.

- Embed a static fragment with `{{ include ".chezmoitemplates/<os>/<name>" | trim }}`.
- Embed a fragment that reads chezmoi data with `{{ includeTemplate "<os>/<name>" . | trim }}`.
- Skip the `template` action for fragments, as it can't be piped to `trim`.
- A fragment runs in the parent's shell with the parent's options, so it has no shebang and no `set`.
- Add the `.tmpl` suffix only when the template syntax breaks shellcheck.
- Guard a fragment's body with `if` instead of calling `exit`, which would end the parent.

## Agent plugins

Set an unselected plugin to `false` in `.chezmoitemplates/plugins.json.tmpl`, because the sync uninstalls `false` entries and leaves deleted ones installed.

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

Run `shellcheck` on each changed shell script without the `.tmpl` suffix.

## Boundaries

- Read-only chezmoi commands are fine: `cat`, `data`, `diff`, `managed`.
- Every chezmoi command runs `scripts/bootstrap.sh` first, which installs nix on a machine without it.
- Never run `apply`, `init`, `update`, `execute-template` or any other command that changes state, unless asked.

## References

- Context7 library ID for chezmoi docs: `/websites/chezmoi_io`.
