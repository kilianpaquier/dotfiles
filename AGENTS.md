# chezmoi

Dotfiles managed by [chezmoi](https://www.chezmoi.io/).
The source root is `chezmoi/` (`.chezmoiroot`), and paths below are relative to it.

## Run chezmoi

- Expect every chezmoi command to run `scripts/bootstrap.sh` first (the `read-source-state` hook), which installs nix and mise on a machine without them.
- Run `apply`, `init` and `update` only when asked.

## Place a path to ignore, delete or remove

Linux and Windows render their own chezmoi data. Linux has no `.wsl`, Windows has no `.ai`.
Read an OS's data only in its own branch, since the branch not taken is never evaluated.
chezmoi deletes no ignored target and `.chezmoiremove` skips ignored targets, so a managed path leaves a machine through the prune script and an unmanaged one through `.chezmoiremove.tmpl`.

1. Pick the row that matches the path.

   | Path                                         | Example                             | Add it to                           |
   | -------------------------------------------- | ----------------------------------- | ----------------------------------- |
   | Never managed by chezmoi                     | `.cache/uv` once `uv` is deselected | `.chezmoiremove.tmpl`               |
   | Managed here, deleted once deselected        | `.kube` once `k8s` is deselected    | `.chezmoitemplates/deselected.tmpl` |
   | Managed on the other OS                      | `AppData` on Linux                  | `.chezmoitemplates/deselected.tmpl` |
   | Managed here, and a tool or the user owns it | `workspaces` on a Linux desktop     | `.chezmoiignore.tmpl`               |

2. Add the line under the condition of its option, in the branch of the OS that reads that option.
3. Complete the pair for a path that differs by OS.
   - A new Windows-managed path: exclude it in the Windows branch of `.chezmoiignore.tmpl` (`!`, and one `!` per parent directory), and list it in the Linux branch of `deselected.tmpl`.
   - A new Linux path that no option controls: list it in the Windows branch of `deselected.tmpl`.
   - A new Linux path that an option controls: nothing more, since Windows renders `deselected.tmpl` with every option deselected and ignores everything else (`**`).
4. List the files, not the directory, when the tool keeps its own data there (`.ssh/known_hosts`, not `.ssh`), since deleting a directory removes its history and credentials too.
5. After deleting a managed source file, list its target in `.chezmoiremove.tmpl` and drop its entries in `.chezmoidata/sandbox.yaml`, since chezmoi leaves the target in place.

Done when the path sits in exactly one row's file, and in its pair when step 3 applies.

## Place an environment variable

- Put a variable a mise tool or an agent reads in `[env]` of `private_dot_config/mise/conf.d/10-settings.toml`, keys alphabetical.
- Put a variable the login shell needs before mise runs in `symlinks/.profile` (`MISE_ENV`).
- Never put one in `symlinks/.env.zsh`, which only configures zsh.

## Add a tool or runtime

Check each item against a sibling tool (`docker`, `podman`) before planning:

- Install in `home.nix.tmpl`, completion in `symlinks/.env.zsh`.
- Config, after asking which keys chezmoi owns (a plain file) and which stay the tool's (a `modify_` script).
- Path rows under "Place a path to ignore, delete or remove", and a stop or prune script when the tool leaves a process behind.
- README prompt row and runtime section.
- Every consumer of the option (`container.engine` feeds gitlab-ci-local).

## Write a modify script

- Include the `scripts/<format>-merge.py` of the file's format, which sets only the keys it lists.
- Expect it to write nothing while the file doesn't exist, so a value the tool needs on its first run needs a plain file.
- Never add a key to a `scripts/*-merge.py` that its other callers don't pass, since chezmoi fails on a missing key (`missingkey=error`).
- Name a file of many keys `<name>.partial.<ext>`, since `.chezmoiignore.tmpl` skips `**/*.partial.*`.

## Write a script

- Start a script that reruns when upstream drifts on its own with a date stamp, like the mise tools one: `# date: {{ now | date "2006-01-02" }}`.
- Record the hash of a file outside the script's body, so `run_onchange_` reruns: `# mise config: {{ includeTemplate "…" . | sha256sum }}`.
- Embed a static fragment with `include` and a fragment that reads chezmoi data with `includeTemplate`.

## Keep files in sync

Change the second file in the same commit as the first:

- A prompt in `.chezmoi.yaml.tmpl` and its row in the README prompts table.
- A desktop app in `home.nix.tmpl` and in `winget-sync.ps1`.
- A tool permission in `private_dot_claude/settings.partial.json` (`permissions`) and in `dot_vscode-server/data/Machine/settings.copilot.partial.json` (`chat.tools.terminal.autoApprove`).
- A URL permission in `private_dot_claude/settings.partial.json` (`WebFetch(domain:…)`), `private_dot_copilot/settings.partial.json` (`allowedUrls`) and `dot_vscode-server/data/Machine/settings.copilot.partial.json` (`chat.tools.urls.autoApprove`).
- A host the agents reach in `.chezmoidata/sandbox.yaml` (`sandbox.network.allow`), which srt and the sbx tools kit render.
- A path or host an agent reaches in `.chezmoidata/sandbox.yaml`, never inline in a sandbox template, so every sandbox renders it.
