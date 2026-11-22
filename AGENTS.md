# dotfiles

Dotfiles managed by [**chezmoi**](https://www.chezmoi.io/) for **Linux** (**WSL** included) and **Windows**.
The source state lives in `chezmoi/` (`.chezmoiroot`), and paths below are relative to it, except `symlinks/` at the repository root.

- Work from the source files and templates, and leave every **chezmoi** command to the user (`apply`, `diff`, `cat` and `execute-template` included).
- Report a render you didn't see as not verified.
- Keep a list that several templates render (tools, sandbox paths and hosts) in `.chezmoidata/`, so each template reads that one copy.
- Write JSON and JSON templates with a 4-space indent, YAML lists in block style (`[]` when empty), and home paths as `~/`.

## Agent configuration

Each runtime of `agent_runtimes` (`.chezmoidata/tools.yaml`) gets the same setup through its own files, so an entry lands in every file of its **pair** in the same commit.

- A tool permission goes in `private_dot_claude/settings.partial.json` (`permissions`) and `dot_vscode-server/data/Machine/settings.copilot.partial.json` (`chat.tools.terminal.autoApprove`).
- [**Copilot CLI**](https://docs.github.com/en/copilot/how-tos/copilot-cli) takes tool permissions only as `--allow-tool` flags, so it has no entry.
- A URL permission goes in `private_dot_claude/settings.partial.json` (`WebFetch(domain:…)`), `private_dot_copilot/settings.partial.json` (`allowedUrls`) and `dot_vscode-server/data/Machine/settings.copilot.partial.json` (`chat.tools.urls.autoApprove`).
- A path or host an agent reaches goes in `.chezmoidata/sandbox.yaml`, which every sandbox renders.
- A host listed in `sandbox.network.allow_domain` is allowed, one in `deny_domain` or on a `deny_port` is blocked, and any other host asks.
- A token comes from [**gopass**](https://www.gopass.pw) (**git**'s credential helper here), so a tool or sandbox reaches **gopass** instead of an exported variable.

Done when every file of the pair carries the entry.

## Paths across OSes

**Linux** and **Windows** render their own **chezmoi** data (**Linux** has no `.wsl`, **Windows** has no `.ai`).
A template reads an OS's data only in that OS's branch, since the branch not taken is never evaluated.
Neither **chezmoi** nor `.chezmoiremove` deletes an ignored target.
A managed path therefore leaves a machine through `.chezmoitemplates/deselected.tmpl`, and an unmanaged one through `.chezmoiremove.tmpl`.

1. Pick the row that matches the path.

   | Path                                         | Example                             | Add it to                           |
   | -------------------------------------------- | ----------------------------------- | ----------------------------------- |
   | Never managed by **chezmoi**                 | `.cache/uv` once `uv` is deselected | `.chezmoiremove.tmpl`               |
   | Managed here, deleted once deselected        | `.kube` once `k8s` is deselected    | `.chezmoitemplates/deselected.tmpl` |
   | Managed on the other OS                      | `AppData` on **Linux**              | `.chezmoitemplates/deselected.tmpl` |
   | Managed here, and a tool or the user owns it | `workspaces` on a **Linux** desktop | `.chezmoiignore.tmpl`               |

2. Add it as a plain line under its option's condition, in the branch of the OS that reads that option.
3. Give a path that differs by OS its **pair**.
   - A **Windows**-only path also goes in the **Linux** branch of `deselected.tmpl`.
   - A **Linux** path that no option controls also goes in the **Windows** branch of `deselected.tmpl`.
   - A **Linux** path that an option controls needs nothing more, since **Windows** renders `deselected.tmpl` with every option deselected.
4. List the files rather than the directory when the tool keeps its own data there (`.ssh/known_hosts`, not `.ssh`), since deleting a directory removes its history and credentials too.
5. When the change deletes a managed source file, list its target in `.chezmoiremove.tmpl`, since **chezmoi** leaves the target in place.

Done when the path sits in exactly one row's file, plus its pair from step 3.

## Tools

Start from a sibling tool (*e.g.* `docker` or `podman`), and give the new one each item the sibling has.

- A CLI gets its bundle in `private_dot_config/mise/modify_config.toml.py.tmpl` and its name in the `tools.mise` choices of `.chezmoidata/tools.yaml`.
- A system package or desktop app goes in `home.nix.tmpl`, and a desktop app in `winget-sync.ps1` too.
- A CLI that prints its own **zsh** completion gets a line in `ZSH_COMPLETIONS` of `symlinks/.env.zsh`.
- Ask which config keys **chezmoi** owns (a plain file) and which stay the tool's (a `modify_` script), since the user decides per tool.
- Its paths go through "Paths across OSes", plus a stop or prune script when the tool leaves a process behind.
- A new prompt in `.chezmoi.yaml.tmpl` gets its row in the README prompts table, a new bundle its row in the "Tooling" table, and a tool with its own setup its README section.
- Every consumer of an option it adds follows (*e.g.* `container.engine` feeds `dot_gitlab-ci-local`).

Done when the sibling has no item the new tool lacks.

## Environment variables

- A variable a [**mise**](https://mise.jdx.dev/) tool or an agent reads goes in `[env]` of `private_dot_config/mise/conf.d/10-settings.toml.tmpl`, keys alphabetical.
- A variable the login shell needs before **mise** runs (`MISE_ENV`) goes in `symlinks/.profile`.
- The `symlinks/.env.zsh` file holds **zsh**'s own configuration only.

## Modify scripts

- A modify script includes the `.chezmoitemplates/scripts/<format>-merge.py` of its file's format, which sets only the keys it lists.
- A modify script writes nothing while its file doesn't exist, so a value the tool needs on its first run takes a plain file.
- Pass every key a `*-merge.py` takes (an empty list when unused), and add one only with all its callers passing it, since **chezmoi** fails on a missing key (`missingkey=error`).
- A file of many keys, its conditions included, goes in `<name>.partial.<ext>`, which `.chezmoiignore.tmpl` skips.

## Scripts

- Gate a script or file that only some options need through its path in `.chezmoiignore.tmpl`, so its body stays unconditional.
- Rerun a script when a file changes by hashing that file in a comment: `# mise config: {{ includeTemplate "…" . | sha256sum }}`.
- Stamp the date (`# date: {{ now | date "2006-01-02" }}`, as the **mise** tools script does) only on a script that must rerun daily for upstream drift.
- Embed a static fragment with `include`, and one that reads **chezmoi** data with `includeTemplate`.
