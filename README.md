# dotfiles <!-- omit in toc -->

<div align="center">

<!-- BEGIN_KICKR_BADGES -->
[![GitLab Issues](https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge)](https://gitlab.com/kilianpaquier/dotfiles/-/work_items)
[![GitLab License](https://img.shields.io/gitlab/license/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge)](https://gitlab.com/kilianpaquier/dotfiles/-/blob/HEAD/LICENSE)
[![GitLab CICD](https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge)](https://gitlab.com/kilianpaquier/dotfiles/-/pipelines?ref=main)
[![Plumber Score](https://img.shields.io/endpoint?url=https%3A%2F%2Fscore.getplumber.io%2Fgitlab.com%2Fkilianpaquier%2Fdotfiles.json&style=for-the-badge)](https://score.getplumber.io/gitlab.com/kilianpaquier/dotfiles)
<!-- END_KICKR_BADGES -->

</div>

---

- [Install](#install)
  - [Linux](#linux)
  - [Windows](#windows)
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
  - [Credentials](#credentials)
  - [Agent components](#agent-components)
  - [Agent sandboxes](#agent-sandboxes)
  - [Servers](#servers)
  - [WSL](#wsl)

My own dotfiles repository, it provides dotfiles (obviously) but also user tools installation (using **mise**)
and user level packages (CLI tools, desktop apps, container engines, agent runtimes).

Drift detection and reconciliation is managed with **chezmoi** for dotfiles
and **home-manager** (nix) for packages.

The **home-manager** commands are integrated into the **chezmoi** ones,
so reviewing drift and reapplying the configuration works the same way for dotfiles and packages.

The repository offers the following main features:
- Shell choice for Linux (`bash` or `zsh`)
- Basic desktop apps for Windows and Linux (see [desktop apps](#desktop-apps))
- User dev tools for Linux
- Generation of an SSH key (ed25519) and **git** identity setup
- Git credentials (HTTPS tokens) stored in **gopass**, see [credentials](#credentials)

Of course to avoid a painful maintenance, the setup is not completely *à la carte*.
Setup is based on [prompts](#prompts) with predefined machine typologies and work profiles.

## Install

### Linux

```sh
umask 022
sh -c "$(curl -sSL https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch main https://gitlab.com/kilianpaquier/dotfiles.git
~/.local/bin/chezmoi diff
# ~/.local/bin/chezmoi apply (raw 'chezmoi' binary can be used afterward)
```

```sh
umask 022
sh -c "$(wget -qO- https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch main https://gitlab.com/kilianpaquier/dotfiles.git
~/.local/bin/chezmoi diff
# ~/.local/bin/chezmoi apply (raw 'chezmoi' binary can be used afterward)
```

> [!important]
> Supported distributions are Debian/Ubuntu, Fedora/RHEL and Arch, with `apt-get`, `dnf` or `pacman`.
> NixOS and Alpine are not supported.
>
> The install needs these tools, and the package providing each depends on the distribution.
>
> - **curl** or **wget**
> - **ssh-keygen**, from `openssh-client`, `openssh-clients` or `openssh`
> - **sudo**, to create `/nix` and for the root-only steps of the [deep dive](#deep-dive)
> - **xz**, from `xz-utils` or `xz`

### Windows

```ps1
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --branch 'main' 'https://gitlab.com/kilianpaquier/dotfiles.git'"
~/.local/bin/chezmoi.exe diff
# ~/.local/bin/chezmoi.exe apply (raw 'chezmoi' binary can be used afterward)
```

## Day to day

- Detect and review drift with `chezmoi diff` or `chezmoi diff /path/to/file` (*e.g.* `~/.env.zsh`)
- Apply a change in your configuration (`chezmoi cat-config` and `chezmoi edit-config`) with `chezmoi apply`
- Retrieve new features and upstream modifications with `chezmoi update`, it only pulls, review with `chezmoi diff` then run `chezmoi apply`
- Reanswer all prompts with `chezmoi init --prompt`

Any tool you add by hand stays put, machines can extend beyond the preset list.

## Machine kind

The repository filters what's installed on a specific machine based on its kind:
- `desktop`: shell and desktop apps, always chosen on Windows
- `workstation`: shell and dev tooling
- `server`: shell, dev tooling, hostname and timezone, not offered on WSL

## Profile

The repository also filters default values to prompts based on profiles, to ease reinstallation and successive installs.
Two profiles exist, `home` and `soprasteria`.

## Prompts

### Every machine

| Prompt                                                                | Default       | When                    | Key             |
| --------------------------------------------------------------------- | ------------- | ----------------------- | --------------- |
| Name for this machine, used as the SSH key comment or server hostname | hostname      |                         | `machine.name`  |
| Username used as git committer and in the SSH key comment             | home dir name |                         | `user.username` |
| What kind of machine this is (`desktop`, `workstation`, `server`)     | `workstation` | Linux                   | `machine.kind`  |
| Default shell (`bash` or `zsh`)                                       | `zsh`         | Linux                   | `shell`         |
| Default shell (`git-bash` or `powershell`)                            | `powershell`  | Windows                 | `shell`         |
| Which work profile applies (`home` or `soprasteria`)                  |               |                         | `profile`       |
| Whether this is a gaming machine (adds EA, Epic, Steam, Ubisoft...)   | `false`       | Windows, `home` profile | `gaming`        |
| Whether to install and configure WSL                                  | `true`        | Windows                 | `wsl`           |
| Which IDEs to install (`intellij`, `vscode`, `zed`)                   | `vscode`      |                         | `ide`           |

### Workstation and server

| Prompt                                                               | Default                | When                  | Key                  |
| -------------------------------------------------------------------- | ---------------------- | --------------------- | -------------------- |
| Email to use as git committer                                        |                        |                       | `user.email`         |
| Whether to sign commits with the SSH key                             | `true`                 |                       | `git.ssh`            |
| Which AI agent runtimes to install (`claude`, `copilot`)             | Depends on the profile |                       | `ai.runtimes`        |
| Which agent plugins to enable (`cave-talk`, `humanizer`, `ponytail`) | Depends on the profile | at least one agent    | `ai.plugins`         |
| Which sandboxes to run the agents in (`nono`, `sbx`, `srt`)          |                        | at least one agent    | `ai.sandboxes`       |
| Which container runtimes to install (`docker` rootless, `podman`)    | Depends on the profile |                       | `container.runtimes` |
| Which container engine gitlab-ci-local should use                    |                        | two runtimes selected | `container.engine`   |
| Which tool manager to use (`mise`)                                   | `mise`                 |                       | `tools_management`   |
| Which tool bundles to install, see [Tooling](#tooling)               | Depends on the profile | `mise` selected       | `tools.mise`         |

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
Having symlinks is as such convenient since **chezmoi** will not detect drift and use **git** to apply changes.

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
| `history`          | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Timestamps each command, writes it immediately, and shares it live across sessions, deduping repeats |
| `completions`      | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Caches shell completions of the tools listed in `ZSH_COMPLETIONS` (edit it in `~/.env.zsh`)          |
| `disk-cleanup`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Adds a `disk-cleanup` command that clears dev-tool caches and old installed versions                 |
| `highlight-styles` | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Removes the underline zsh's syntax highlighting puts on commands                                     |
| `release-sync`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | Adds a `release-sync` command that syncs releases between **GitHub** and **GitLab**                  |

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
| Firefox                         | x     | x       | `soprasteria` profile |
| Office, Teams, Obsidian         |       | x       | `soprasteria` profile |
| WSL                             |       | x       | `wsl`                 |

> [!note]
> On Linux, `sudo` is asked for your password to install the `pcscd` package with the system package manager,
> and to link the GPU drivers.

### Tooling

Dev tools are grouped into bundles that [**mise**](https://mise.jdx.dev) installs.
The next apply reconciles them with your **chezmoi** configuration, so a tool you select or add gets installed while one you unselect or remove gets uninstalled.
Anything you installed by hand with **mise** stays, unless **chezmoi** manages it.

Secrets such as `GITLAB_TOKEN` go in the `[env]` table of `~/.config/mise/config.secrets.toml` (not reachable by sandboxed agents),
which **chezmoi** creates empty and never overwrites.
Either paste the value directly, or read it from **gopass** when the store should stay the only place holding it.

```toml
[env]
GITLAB_TOKEN = "glpat-xxxxxxxxxxxxxxxxxxxx"
GITHUB_TOKEN = "{{ exec(command='gopass show -o dev/github/token') }}"
```

Avoid `cache_duration` and `cache_key` on `exec`, since **mise** then keeps the value in plaintext in its cache directory.

The following tools are always installed without capability to skip them: age, cosign, node 24, sops, usage.

| Bundle                      | Installs                                          | Home profile defaults | Sopra Steria profile defaults |
| --------------------------- | ------------------------------------------------- | --------------------- | ----------------------------- |
| `agentsview`                | agentsview                                        | x                     | x                             |
| `bun`                       | bun                                               | x                     |                               |
| `codegraph`                 | codegraph                                         | x                     | x                             |
| `context7`                  | context7, context7-mcp                            | x                     | x                             |
| `destructive-command-guard` | destructive-command-guard                         | x                     | x                             |
| `gh`                        | gh                                                | x                     |                               |
| `gitlab-ci-local`           | gitlab-ci-local                                   | x                     | x                             |
| `glab`                      | glab                                              | x                     |                               |
| `go`                        | go, golangci-lint                                 | x                     | x                             |
| `hugo`                      | dart-sass, hugo-extended                          | x                     | x                             |
| `incus`                     | incus                                             | x                     |                               |
| `java`                      | java (LTS), maven                                 |                       | x                             |
| `just`                      | just                                              | x                     |                               |
| `k8s`                       | helm, helm-ct, helmfile, krew, kubectl, kustomize | x                     | x                             |
| `kotlin`                    | kotlin                                            |                       |                               |
| `mempalace`                 | mempalace                                         | x                     | x                             |
| `opentofu`                  | opentofu, tflint, tofu-ls                         | x                     |                               |
| `pre-commit`                | pre-commit                                        | x                     | x                             |
| `pulumi`                    | pulumi                                            |                       |                               |
| `rtk`                       | rtk                                               | x                     | x                             |
| `shell`                     | bash-language-server, shellcheck                  | x                     | x                             |
| `terraform`                 | terraform, terraform-ls, tflint                   |                       | x                             |
| `uv`                        | uv                                                | x                     | x                             |

### Container runtimes

Two main container runtimes can be installed:
- `docker`: rootless docker.
- `podman`: podman, podman-compose (default compose provider) and docker-compose (opt-in with `PODMAN_COMPOSE_PROVIDER=docker-compose`), rootless by default.

> [!important]
> Rootless containers need `uidmap` and linger, which `chezmoi apply` installs when they are missing
> and asks for your `sudo` password.
> Without linger (or without systemd), rootless docker doesn't start at boot and stops with your last login session.

#### Limitations

- Rootless docker can't bind ports below 1024 by default, updates can be done in `/proc/sys/net/ipv4/ip_unprivileged_port_start`.
- Rootless docker can't publish a port inside the kernel's ephemeral range (`/proc/sys/net/ipv4/ip_local_port_range`, usually `32768 60999`).

### Credentials

On every machine, Windows included, the first apply:
- Generates the SSH key `~/.ssh/id_ed25519` and asks for its passphrase (empty allowed)
- Prints the public key to paste into **GitLab** or **GitHub**
- Only updates the key comment on a later change of `user.username` or `machine.name`

On Linux workstations and servers, **gopass** is installed with **home-manager** and:
- Is the **git** credential helper for HTTPS remotes
- Exposes the store as a Secret Service through a user service, so `gh` and `glab` keep their tokens in it
- Stores the registry credentials of `docker login` and `podman login`, when a container runtime is selected

> [!warning]
> A login made before this change stays in `~/.docker/config.json` until you log out and in again.

The first apply creates the **gopass** store and asks for the passphrase (empty not allowed) protecting its new identity.
The **age** agent locks again after an hour.

While it's locked:
- **git** prompts for a username and password on HTTPS remotes
- `gh` and `glab` report a missing token
- `docker` and `podman` fail to log in or pull from a private registry

After login or a timeout, unlock the agent then list its identities once, so `gh` and `glab` can also write refreshed tokens:

```sh
gopass age agent unlock
gopass age identities

gopass age agent status
gopass age agent lock
```

### Agent components

The following components improve agent generation, responses and consumption.
Which ones are installed depends on the chosen runtime, the tools installed with **mise** and the prompt choices.

| Component                   | Type               | Source                                                             | When                                                     |
| --------------------------- | ------------------ | ------------------------------------------------------------------ | -------------------------------------------------------- |
| `agent-rules`               | Instructions       | [agent-rules](https://gitlab.com/kilianpaquier/agent-rules)        | `claude` and `copilot` only                              |
| `bash-language-server`      | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `shell` in `tools.mise`, `claude` and `copilot` only     |
| `cave-talk`                 | Hooks, Skills      | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | `cave-talk` in `ai.plugins`                              |
| `code-simplifier`           | Agents, Skills     | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | always                                                   |
| `codegraph`                 | Hooks, MCP, Skills | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | `codegraph` in `tools.mise`                              |
| `context7`                  | Hooks, MCP, Skills | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | `context7` in `tools.mise`                               |
| `destructive-command-guard` | Hooks              | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | `destructive-command-guard` in `tools.mise`              |
| `docker`                    | Skills             | [docker/skills](https://github.com/docker/skills)                  | At least one `container.runtimes` selected               |
| `exam-drill`                | Skills             | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | always                                                   |
| `feature-dev`               | Agents, Skills     | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | always                                                   |
| `find-skills`               | Skills             | [vercel-labs/skills](https://github.com/vercel-labs/skills)        | always                                                   |
| `go`                        | Skills             | [spf13/go-skills](https://github.com/spf13/go-skills)              | `go` in `tools.mise`                                     |
| `gopls`                     | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `go` in `tools.mise`, `claude` and `copilot` only        |
| `grill-me`, `grilling`      | Skills             | [mattpocock/skills](https://github.com/mattpocock/skills)          | always                                                   |
| `humanizer`                 | Skills             | [humanizer](https://github.com/blader/humanizer)                   | `humanizer` in `ai.plugins`                              |
| `jdtls`                     | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `java` in `tools.mise`, `claude` and `copilot` only      |
| `kotlin-lsp`                | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `kotlin` in `tools.mise`, `claude` and `copilot` only    |
| `mempalace`                 | Hooks, MCP, Skills | [mempalace](https://github.com/mempalace/mempalace)                | `mempalace` in `tools.mise`                              |
| `ponytail`                  | Hooks, Skills      | [ponytail](https://github.com/DietrichGebert/ponytail)             | `ponytail` in `ai.plugins`                               |
| `schema-converter`          | Skills             | [one-for-all](https://github.com/kilianpaquier/ai-integration)     | always                                                   |
| `terraform-ls`              | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `terraform` in `tools.mise`, `claude` and `copilot` only |
| `tofu-ls`                   | Language server    | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps) | `opentofu` in `tools.mise`, `claude` and `copilot` only  |

### Agent sandboxes

The `ai.sandboxes` prompt picks how your agents are isolated, on the host with **nono** or **srt**, or in a microVM with **sbx**.

#### Host sandbox

Start the agent from `~/workspaces` or the **chezmoi** source directory, through
[**nono**](https://nono.sh) or [**srt**](https://github.com/anthropic-experimental/sandbox-runtime):

```sh
nono run claude
nono run copilot

srt claude
srt copilot
```

The agent works on your projects without seeing your secrets, while still signing commits and calling **GitLab** and **GitHub** with your credentials.
It can't change its own settings, hooks or plugins, and it can't install tools, run containers, reach databases or `git push`, so you do those yourself.

> [!warning]
> A plain `claude` or `copilot`, or an agent your IDE starts, runs with no sandbox at all.

#### Full sandbox (sbx)

For unattended runs, untrusted repositories or long tasks, [**Docker Sandboxes**](https://docs.docker.com/ai/sandboxes/) runs the whole agent in a microVM, provided your user is in the `kvm` group.
Your **GitLab** and **GitHub** tokens stay on the host, and the agent signs commits with your SSH key but can't log in to either over SSH.
As with the host sandboxes, it reaches allowlisted hosts without asking and asks you before any other.

Set it up once, then start an agent from a project:

```sh
sbx login
sbx secret set anthropic                        # Claude Code API key, or /login inside the sandbox for a subscription
sbx secret set github --command 'gh auth token' # gh, and Copilot sign-in
sbx secret set gitlab                           # GitLab token with the api scope
sbx env run
```

### Servers

On a `server` machine kind, the setup also changes the OS configuration:
- The hostname is set from `machine.name`.
- The timezone is set from `machine.timezone`.

### WSL

A WSL2 distribution is set up as an isolated, VPS-like machine, cut off from the Windows host.
Running inside one is detected without a prompt.

Two files drive the setup, `wsl.conf` inside the distro and `.wslconfig` on the Windows host.
The latter needs the dotfiles installed on Windows too, with the `wsl` prompt set to `true`, and that install is worth it.

Without it, the distro disk can grow up to 1TB and fill the Windows drive, while with it the setup:
- Caps the disk at 60GB
- Limits the distro to 75% of the host processors (rounded up)
- Hands unused memory back to Windows gradually

| File         | Location                  | Scope               | Sets                                                                                                  |
| ------------ | ------------------------- | ------------------- | ----------------------------------------------------------------------------------------------------- |
| `.wslconfig` | Windows (`%UserProfile%`) | Global, all distros | `memory` at half, `processors` at 75%, `swap=8GB`, `defaultVhdSize=60GB`, `autoMemoryReclaim=gradual` |
| `wsl.conf`   | Linux (`/etc/wsl.conf`)   | This distro only    | `automount`, `interop` and `appendWindowsPath` off, `systemd` on, `hostname` from `machine.name`      |

Keep in mind that:
- Either file only takes effect after `wsl.exe --shutdown` from Windows and reopening the distro.
- Applying inside the distro asks for your `sudo` password, to write `/etc/wsl.conf`, to link the GPU drivers and to install the following packages:
  - D-Bus user session (for **gopass** keyring service)
  - OpenSSH client (for SSH key generation and usage)
  - UID and GID mapping tools, `uidmap` on Debian (for rootless containers)
- With **VS Code**, `"remote.WSL.experimental.scriptLessStartup": true` must be set in the *User Settings*.
