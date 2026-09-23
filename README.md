# dotfiles <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

- [Install](#install)
- [Day to day](#day-to-day)
- [Machine kind](#machine-kind)
- [Profile](#profile)
- [Prompts](#prompts)
  - [Every machine](#every-machine)
  - [Workstation and server](#workstation-and-server)
  - [Server only](#server-only)
- [Deep dive](#deep-dive)
  - [Shell](#shell)
  - [Desktop apps](#desktop-apps)
  - [Tooling](#tooling)
  - [Container runtimes](#container-runtimes)
  - [Agent components](#agent-components)
  - [Servers](#servers)
  - [WSL](#wsl)

My own dotfiles repository, it provides dotfiles (obviously) but also user tools installation (using **mise**)
and user level packages (CLI tools, desktop apps, container engines, agent runtimes).

Drift detection and reconciliation is managed with **chezmoi** for dotfiles
and **home-manager** (nix) for packages.

To improve the usage experience, **home-manager** commands are directly integrated within **chezmoi** ones,
offering a uniform experience to review drift and reapply the configuration.

The repository offers the following main features:
- Shell choice for Linux (`bash` or `zsh`)
- Basic desktop apps for Windows and Linux (see [desktop apps](#desktop-apps))
- User dev tools for Linux
- Generation of an SSH key (ed25519) and **git** identity setup

Of course to avoid a painful maintenance, the setup is not completely *à la carte*.
Setup is based on [prompts](#prompts) with predefined machine typologies and work profiles.

## Install

```sh
umask 022
sh -c "$(curl -sSL https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch main --apply https://gitlab.com/kilianpaquier/dotfiles.git
```

```sh
umask 022
sh -c "$(wget -qO- https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch main --apply https://gitlab.com/kilianpaquier/dotfiles.git
```

```ps1
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --branch 'main' --apply 'https://gitlab.com/kilianpaquier/dotfiles.git'"
```

## Day to day

- Detect and review drift with `chezmoi diff` or `chezmoi diff /path/to/file` (*e.g.* `~/.env.zsh`)
- Apply a change in your configuration (`chezmoi cat-config` and `chezmoi edit-config`) with `chezmoi apply`
- Retrieve new features and upstream modifications with `chezmoi update -a=false` (the option disables the auto-apply)
- Reanswer all prompts with `chezmoi init --prompt`

Any tool you add by hand stays put, machines can extend beyond the preset list.

## Machine kind

The repository filters what's installed on a specific machine based on its kind:
- `desktop`: shell and desktop apps
- `workstation`: shell and dev tooling
- `server`: shell, dev tooling, hostname and timezone

*Windows machines are always desktops.*

## Profile

The repository also filters default values to prompts based on profiles, to ease reinstallation and successive installs.
Two profiles exist, `home` and `soprasteria`.

## Prompts

### Every machine

| Prompt                                                                | Default       | When                           | Key             |
| --------------------------------------------------------------------- | ------------- | ------------------------------ | --------------- |
| What kind of machine this is (`desktop`, `workstation`, `server`)     | `workstation` | Linux                          | `machine.kind`  |
| Which work profile applies (`home` or `soprasteria`)                  |               |                                | `profile`       |
| Whether this is a gaming machine (adds EA, Epic, Steam, Ubisoft...)   | `false`       | Windows, `home` profile        | `gaming`        |
| Which shell to use day to day (`bash` or `zsh`)                       | `zsh`         | Linux                          | `shell`         |
| Which IDEs to install (`intellij`, `vscode`, `zed`)                   | `vscode`      |                                | `ide`           |
| Whether to generate an SSH key (`id_ed25519`)                         | `true`        |                                | `ssh.generate`  |
| Name for this machine, used as the SSH key comment or server hostname | hostname      | SSH key or server              | `machine.name`  |
| Username to use as git committer                                      | OS username   | SSH key, workstation or server | `user.username` |
| Email to use as git committer                                         |               | SSH key, workstation or server | `user.email`    |

### Workstation and server

| Prompt                                                            | Default                | When                  | Key                  |
| ----------------------------------------------------------------- | ---------------------- | --------------------- | -------------------- |
| Whether to sign commits with the SSH key                          | `true`                 |                       | `git.ssh`            |
| Which AI agent runtimes to install (`claude`, `codex`, `copilot`) | Depends on the profile |                       | `ai.runtimes`        |
| Which agent plugins to enable (`caveman`, `ponytail`)             | Depends on the profile | at least one agent    | `ai.plugins`         |
| Which container runtimes to install (`docker` rootless, `podman`) | Depends on the profile |                       | `container.runtimes` |
| Which container engine gitlab-ci-local should use                 |                        | two runtimes selected | `container.engine`   |
| Which tool manager to use (`mise`)                                | `mise`                 |                       | `tools_management`   |
| Which tool bundles to install, see [Tooling](#tooling)            | Depends on the profile | `mise` selected       | `tools.mise`         |

### Server only

| Prompt                        | Default | Key                |
| ----------------------------- | ------- | ------------------ |
| Timezone to set on the server | `UTC`   | `machine.timezone` |

## Deep dive

### Shell

Either `bash` or `zsh` can be chosen as shell.

Two particularities:
- `bash` is by default provided when choosing `zsh`
- `zsh` is always enriched with [zsh4humans](https://github.com/romkatv/zsh4humans)

Shell 'rc' files are configured as symlinks since they are the most susceptible ones to be modified per user preferences.
Having symlinks is as such convenient since **chezmoi** will not detect drift and use **git** to apply changes (stash > pull > stash pop).

Below the list of shell files configuration and what they bring to the table.

```tree
~/
│   # shell aliases, used by both bash and zsh
│   # edit this file when modifying, removing or adding new aliases
├── .bash_aliases
├── .bash_logout   # bash login cleanup
├── .bashenv       # sources .profile
├── .bashrc        # bash interactive config
│   # zsh plugins
│   # edit this file when modifying, removing or adding zsh plugins
├── .env.zsh
│   # PATH, umask, mise env, used by both bash and zsh
│   # edit this file when adding new paths to PATH
│   # or when exporting new dev tool environment variables (prefer mise for other environment variables)
├── .profile
├── .zlogout       # zsh login cleanup
├── .zprofile      # sources .profile
└── .zshrc         # zsh interactive config
```

#### zsh plugins

The advantage of zsh is its capability to be extended with plugins.
When choosing zsh here, the following plugins are provided by default within `~/.env.zsh`.

| Plugin             | Source                                                      | Purpose                                                                                              |
| ------------------ | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `ssh-agent`        | [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)               | Starts ssh-agent on shell start and loads your SSH keys into it                                      |
| `history`          | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Timestamps each command, writes it immediately, and shares it live across sessions, deduping repeats |
| `disk-cleanup`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Adds a `disk-cleanup` command that clears dev-tool caches and old installed versions                 |
| `docker-rootless`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Exports `DOCKER_HOST` so the docker CLI targets your rootless daemon                                 |
| `gitlab-ci-local`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Caches `gitlab-ci-local`'s shell completion so it loads instantly                                    |
| `highlight-styles` | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Removes the underline zsh's syntax highlighting puts on commands                                     |
| `just-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Caches `just`'s shell completion so it loads instantly                                               |
| `mise-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Caches `mise`'s shell completion so it loads instantly                                               |
| `release-sync`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Adds a `release-sync` command that syncs releases between GitHub and GitLab                          |
| `task-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Caches `task`'s shell completion so it loads instantly                                               |

### Desktop apps

As stated above in machine kinds part, when choosing a `desktop` kind,
you would most likely want some applications to be installed, the repository extends that to a limited list of apps.

| App                             | Linux | Windows | When                  |
| ------------------------------- | ----- | ------- | --------------------- |
| LibreOffice                     | x     | x       | always                |
| Spotify                         | x     | x       | always                |
| Git, 7zip                       |       | x       | always                |
| VS Code                         | x     | x       | `vscode` in `ide`     |
| Zed                             | x     | x       | `zed` in `ide`        |
| IntelliJ IDEA Ultimate          |       | x       | `intellij` in `ide`   |
| Brave                           | x     | x       | `home` profile        |
| Discord                         | x     | x       | `home` profile        |
| NetBird                         | x     | x       | `home` profile        |
| Nextcloud                       | x     | x       | `home` profile        |
| Yubico Authenticator            | x     | x       | `home` profile        |
| pcscd                           | x     |         | `home` profile        |
| Filen, VeraCrypt, G HUB         |       | x       | `home` profile        |
| .NET runtimes 8, 10             |       | x       | `home` profile        |
| YubiKey Manager, minidriver     |       | x       | `home` profile        |
| CPU-Z, OCCT, HWiNFO             |       | x       | `gaming`              |
| Afterburner, RTSS               |       | x       | `gaming`              |
| EA, Epic, Ubisoft, Steam, WeMod |       | x       | `gaming`              |
| Office, Teams, WSL, Obsidian    |       | x       | `soprasteria` profile |

### Tooling

Dev tools are grouped into bundles, each bundle is a set of tools installed through [**mise**](https://mise.jdx.dev).
Selected, unselected, added, removed tools from the **chezmoi** configuration are reconciled in the next apply.
Tools added by hand with **mise** always stay to ease customization per user, unless such tool is managed by **chezmoi**.

The following tools are always installed without capability to skip them: age, cosign, node 24, sops, usage.

| Bundle                      | Installs                                | Home profile defaults | Sopra Steria profile defaults |
| --------------------------- | --------------------------------------- | --------------------- | ----------------------------- |
| `boost`                     | jfrog-boost                             | x                     | x                             |
| `bun`                       | bun                                     | x                     |                               |
| `codegraph`                 | codegraph                               | x                     | x                             |
| `context7`                  | context7, context7-mcp                  | x                     | x                             |
| `destructive-command-guard` | destructive-command-guard               | x                     | x                             |
| `gh`                        | gh                                      | x                     |                               |
| `gitlab-ci-local`           | gitlab-ci-local                         | x                     | x                             |
| `glab`                      | glab                                    | x                     |                               |
| `go`                        | go, golangci-lint                       | x                     | x                             |
| `hugo`                      | dart-sass, hugo-extended                | x                     | x                             |
| `incus`                     | incus                                   | x                     |                               |
| `java`                      | java (LTS), jdtls                       |                       | x                             |
| `just`                      | just                                    | x                     |                               |
| `k8s`                       | helm, helm-ct, krew, kubectl, kustomize | x                     | x                             |
| `kotlin`                    | kotlin, kotlin-lsp                      |                       |                               |
| `mempalace`                 | mempalace                               | x                     | x                             |
| `opentofu`                  | opentofu, tflint, tofu-ls               | x                     |                               |
| `pre-commit`                | pre-commit                              | x                     | x                             |
| `rtk`                       | rtk                                     |                       |                               |
| `shell`                     | bash-language-server, shellcheck        | x                     | x                             |
| `terraform`                 | terraform, terraform-ls, tflint         |                       | x                             |
| `uv`                        | uv                                      | x                     | x                             |

### Container runtimes

Two main container runtimes can be installed:
- `docker`: rootless docker on the pasta network driver.
- `podman`: podman and podman-compose, rootless by default.

### Agent components

To improve agent generation, responses and consumption, the following components are provided
and installed depending on the chosen runtime, installed tools with **mise** or even prompt choices.

| Component                   | Type               | Source                                                                                           | When                                                     |
| --------------------------- | ------------------ | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| `agent-rules`               | Instructions       | [agent-rules](https://gitlab.com/kilianpaquier/agent-rules), refreshed daily                     | `claude` and `copilot` only                              |
| `bash-language-server`      | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `shell` in `tools.mise`, `claude` and `copilot` only     |
| `caveman`                   | Hooks, Skills      | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | `caveman` in `ai.plugins`                                |
| `code-simplifier`           | Agents, Skills     | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | always                                                   |
| `codegraph`                 | Hooks, MCP, Skills | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | `codegraph` in `tools.mise`                              |
| `context7`                  | Hooks, MCP, Skills | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | `context7` in `tools.mise`                               |
| `destructive-command-guard` | Hooks              | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | `destructive-command-guard` in `tools.mise`              |
| `exam-drill`                | Skills             | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | always                                                   |
| `feature-dev`               | Agents, Skills     | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | always                                                   |
| `find-skills`               | Skills             | [vercel-labs/skills](https://github.com/vercel-labs/skills)                                      | always                                                   |
| `gopls`                     | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `go` in `tools.mise`, `claude` and `copilot` only        |
| `grill-me`, `grilling`      | Skills             | [mattpocock/skills](https://github.com/mattpocock/skills)                                        | always                                                   |
| `jdtls`                     | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `java` in `tools.mise`, `claude` and `copilot` only      |
| `kotlin-lsp`                | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `kotlin` in `tools.mise`, `claude` and `copilot` only    |
| `mempalace`                 | Hooks, MCP, Skills | [mempalace](https://github.com/mempalace/mempalace)                                              | `mempalace` in `tools.mise`                              |
| `ponytail`                  | Hooks, Skills      | [ponytail](https://github.com/DietrichGebert/ponytail)                                           | `ponytail` in `ai.plugins`                               |
| `protected-paths`           | Hooks              | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | always                                                   |
| `schema-converter`          | Skills             | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | always                                                   |
| `terraform-ls`              | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `terraform` in `tools.mise`, `claude` and `copilot` only |
| `tofu-ls`                   | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `opentofu` in `tools.mise`, `claude` and `copilot` only  |

### Servers

When choosing `server` as machine kind, small modifications can be done onto the OS configuration itself (`sudo` is needed in such cases):
- The hostname can be changed, retrieved from `machine.name`.
- The timezone can be changed, retrieved from `machine.timezone`.

### WSL

Running inside a WSL2 distribution is auto-detected (no prompt), by checking whether `microsoft` appears in the running kernel release.
It configures an isolated distro, cut off from the Windows host, sized like a small VPS (Virtual Private Server):

| File         | Side                      | Scope               | Sets                                                                                                   |
| ------------ | ------------------------- | ------------------- | ------------------------------------------------------------------------------------------------------ |
| `.wslconfig` | Windows (`%UserProfile%`) | Global, all distros | `memory=8GB`, `processors=4`, `defaultVhdSize=60GB`                                                    |
| `wsl.conf`   | Linux (`/etc/wsl.conf`)   | This distro only    | `automount` off (no `/mnt/c`, `/mnt/d`), `interop` off (no Windows process launch, no Windows `$PATH`) |

> [!note]
> A `wsl.conf` change only takes effect after `wsl.exe --shutdown` from Windows and reopening the distro.

> [!note]
> When using **VSCode**, the setting `"remote.WSL.experimental.scriptLessStartup": true` must be defined in the *User Settings*.
