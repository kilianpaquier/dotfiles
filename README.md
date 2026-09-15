# dotfiles <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

## Install

```sh
umask 022
sh -c "$(curl -sSL https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch main --apply https://gitlab.com/kilianpaquier/dotfiles.git
```

```ps1
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --branch 'main' --apply 'https://gitlab.com/kilianpaquier/dotfiles.git'"
```

In case you'd want to change your initial responses to prompts:

```sh
chezmoi init --prompt
```

## Prompts

| Description                                                                           | Type        | OS          | Default                                              | When                                    | Key                |
| ------------------------------------------------------------------------------------- | ----------- | ----------- | ---------------------------------------------------- | --------------------------------------- | ------------------ |
| Development machine (enables git, agents, tool managers, skips desktop apps and IDEs) | bool        | non-windows | `true`                                               |                                         | `dev`              |
| Work profile: `home` or `soprasteria`                                                 | choice      | all         |                                                      |                                         | `profile`          |
| Gaming machine (installs EA, Epic, Steam, Ubisoft...)                                 | bool        | windows     | `false`                                              | `profile` == `home`                     | `gaming`           |
| Shell to configure: `bash` or `zsh`                                                   | choice      | non-windows | `zsh`                                                |                                         | `shell`            |
| IDEs in use: `intellij` (windows only), `vscode`, `zed`                               | multichoice | all         | `vscode`                                             |                                         | `ide`              |
| Generate an SSH key (`id_ed25519`)                                                    | bool        | all         | `true`                                               |                                         | `ssh.generate`     |
| Computer name (used in the SSH key comment)                                           | string      | all         | hostname                                             | `ssh.generate`                          | `machine_name`     |
| Committer email address                                                               | string      | all         |                                                      | `dev` or `ssh.generate`                 | `user.email`       |
| Username                                                                              | string      | all         | OS username                                          | `dev` or `ssh.generate`                 | `user.username`    |
| Sign commits with SSH key                                                             | bool        | non-windows | `true`                                               | `dev`                                   | `git.ssh`          |
| AI agents to configure: `claude`, `codex`, `copilot`                                  | multichoice | non-windows | `claude`, `copilot` (home) / `copilot` (soprasteria) | `dev`                                   | `ai.agents`        |
| Agent plugins to install: `caveman`, `ponytail`                                       | multichoice | non-windows | `caveman`, `ponytail`                                | `ai.agents` non-empty                   | `ai.plugins`       |
| Tool manager(s) to use: `mise`. See [Tooling](#tooling) below                         | multichoice | non-windows | `mise`                                               | `dev`                                   | `tools_management` |
| Tools to install with mise. See [Tooling](#tooling) below                             | multichoice | non-windows |                                                      | `dev` and `tools_management` has `mise` | `tools.mise`       |

## Tooling

### Shell

The `shell` prompt picks `bash` or `zsh` (selecting the latter also provide the setup for the former),
installed through apt with base packages (`bash-completion`, `curl`, `git`, `jq`, `make`, `ripgrep`, `vim`, `yq`, etc.).
Dotfiles are symlinks into the chezmoi source, editing them in place edits the repository (easier for maintenance and updatability).

What both shells get:

- `~/.profile` sets `umask 022`, builds the PATH (`~/bin`, `~/.local/bin`, bun, mise shims, krew, `GOBIN`), loads `mise env` and points Go caches to `~/.cache`.
- `~/.bash_aliases` colors `ls` and `grep`, adds `ll`, `la`, `lla`, `l`, and short names for tools when they are installed: `dc` (docker compose), `gcl` (gitlab-ci-local), `k` (kubectl), `tf` (terraform).

On top of that:

- `bash` exports `BASH_ENV` (`~/.config/environment.d/bash.conf`) so non-interactive shells also source `~/.profile`.
- `zsh` runs on [zsh4humans](https://github.com/romkatv/zsh4humans) v5, with `~/.zshenv` refreshed weekly
  and a few tweaks in `~/.zshrc` (pc keyboard, right arrow accepts autosuggestions, no auto-update, no tmux, no direnv).

> [!tip]
> Further tuning and custom ZSH plugins can be added in the `~/.env.zsh`.

#### Plugins ZSH

`~/.env.zsh` loads a handful of plugins on top of zsh4humans.

| Plugin             | Source                                                      | Purpose                                                           |
| ------------------ | ----------------------------------------------------------- | ----------------------------------------------------------------- |
| `ssh-agent`        | [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)               | starts ssh-agent and loads keys                                   |
| `history`          | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | timestamps, immediate write, shared history, dedup                |
| `disk-cleanup`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | `disk-cleanup` command: clears dev-tool caches and stale versions |
| `docker-rootless`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | exports `DOCKER_HOST` for rootless docker                         |
| `gitlab-ci-local`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | cached completion                                                 |
| `highlight-styles` | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | removes underline from syntax highlighting                        |
| `just-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | cached completion                                                 |
| `mise-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | cached completion                                                 |
| `release-sync`     | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | `release-sync` command: sync releases between GitHub and GitLab   |
| `task-completion`  | [zsh-plugins](https://github.com/kilianpaquier/zsh-plugins) | cached completion                                                 |

### Desktop

Desktop apps install only when `dev` is false, through apt on linux and winget on windows.

| App                             | linux | windows | When                       |
| ------------------------------- | ----- | ------- | -------------------------- |
| LibreOffice                     | x     | x       | always                     |
| Spotify                         | x     | x       | always                     |
| wayland-scroll-factor           | x     |         | always                     |
| Git, 7zip                       |       | x       | always                     |
| VS Code                         | x     | x       | `ide` has `vscode`         |
| Zed                             | x     | x       | `ide` has `zed`            |
| IntelliJ IDEA Ultimate          |       | x       | `ide` has `intellij`       |
| Brave                           | x     | x       | `profile` == `home`        |
| Discord                         | x     | x       | `profile` == `home`        |
| NetBird                         | x     | x       | `profile` == `home`        |
| Nextcloud                       | x     | x       | `profile` == `home`        |
| Yubico Authenticator            | x     | x       | `profile` == `home`        |
| pcscd                           | x     |         | `profile` == `home`        |
| Filen, VeraCrypt, G HUB         |       | x       | `profile` == `home`        |
| .NET runtimes 8, 10             |       | x       | `profile` == `home`        |
| YubiKey Manager, minidriver     |       | x       | `profile` == `home`        |
| CPU-Z, OCCT, HWiNFO             |       | x       | `gaming`                   |
| Afterburner, RTSS               |       | x       | `gaming`                   |
| EA, Epic, Ubisoft, Steam, WeMod |       | x       | `gaming`                   |
| Office, Teams, WSL, Obsidian    |       | x       | `profile` == `soprasteria` |

### AI

When at least one AI agent is selected, the selected CLIs (`claude`, `codex`, `copilot`)
and [**apm**](https://github.com/microsoft/apm) are installed and updated on every `chezmoi apply`.

Components come through three channels: `apm` (`~/.apm/apm.yml`), `plugin` (each agent's marketplace) and `chezmoi` (externals and templates).

| Component              | Type               | Via             | Source                                                                                           | Agents              | When                         |
| ---------------------- | ------------------ | --------------- | ------------------------------------------------------------------------------------------------ | ------------------- | ---------------------------- |
| `agent-rules`          | Instructions       | chezmoi         | [agent-rules](https://gitlab.com/kilianpaquier/agent-rules), refreshed daily                     | `claude`, `copilot` | always                       |
| `code-simplifier`      | Agents, Skills     | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | always                       |
| `exam-drill`           | Skills             | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | always                       |
| `feature-dev`          | Agents, Skills     | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | always                       |
| `find-skills`          | Skills             | apm             | [vercel-labs/skills](https://github.com/vercel-labs/skills)                                      | all                 | always                       |
| `grill-me`, `grilling` | Skills             | apm             | [mattpocock/skills](https://github.com/mattpocock/skills)                                        | all                 | always                       |
| `protected-paths`      | Hooks              | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | always                       |
| `schema-converter`     | Skills             | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | always                       |
| `caveman`              | Hooks, Skills      | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | `ai.plugins` has it          |
| `ponytail`             | Hooks, Skills      | plugin          | [ponytail](https://github.com/DietrichGebert/ponytail)                                           | all                 | `ai.plugins` has it          |
| `codegraph`            | Hooks, MCP, Skills | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | `tools.mise` has it          |
| `context7`             | Hooks, MCP, Skills | plugin          | [one-for-all](https://github.com/kilianpaquier/ai-integration)                                   | all                 | `tools.mise` has it          |
| `mempalace`            | Hooks, MCP, Skills | plugin          | [mempalace](https://github.com/mempalace/mempalace)                                              | all                 | `tools.mise` has it          |
| `bash-language-server` | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `shell`     |
| `gopls`                | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `go`        |
| `jdtls`                | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `java`      |
| `kotlin-lsp`           | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `kotlin`    |
| `terraform-ls`         | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `terraform` |
| `tofu-ls`              | Language server    | plugin, chezmoi | [claude-code-lsps](https://github.com/piebald-ai/claude-code-lsps), `~/.copilot/lsp-config.json` | `claude`, `copilot` | `tools.mise` has `opentofu`  |

### Mise

Selected bundles land in `~/.config/mise/config.toml` and get installed, upgraded and pruned on every `chezmoi apply`.
Deselecting `mise` removes all tool dependencies, installations and directories, leaving a cleaned machine.

While **mise** has a large panel of installable tools, only the ones I use most are exposed as prompt choices.
Any other **mise** registered tool can still be installed manually at any time without having `chezmoi apply` removing them
(unless those are not selected).

The following table provides the list of default bundles to be installed depending on the chosen work profile.

| Bundle            | Installs                                          | home | soprasteria |
| ----------------- | ------------------------------------------------- | ---- | ----------- |
| `bun`             | `bun`                                             | x    |             |
| `codegraph`       | `codegraph`                                       | x    | x           |
| `context7`        | `context7`, `context7-mcp`                        | x    | x           |
| `gh`              | `gh`                                              | x    |             |
| `gitlab-ci-local` | `gitlab-ci-local`                                 | x    | x           |
| `glab`            | `glab`                                            | x    |             |
| `go`              | `go`, `golangci-lint`                             | x    | x           |
| `hugo`            | `dart-sass`, `hugo-extended`                      | x    | x           |
| `incus`           | `incus`                                           | x    |             |
| `java`            | `java` (LTS), `jdtls`                             |      | x           |
| `just`            | `just`                                            | x    |             |
| `k8s`             | `helm`, `helm-ct`, `krew`, `kubectl`, `kustomize` | x    | x           |
| `kotlin`          | `kotlin`, `kotlin-lsp`                            |      |             |
| `mempalace`       | `mempalace`                                       | x    | x           |
| `opentofu`        | `opentofu`, `tflint`, `tofu-ls`                   | x    |             |
| `pre-commit`      | `pre-commit`                                      | x    | x           |
| `rtk`             | `rtk`                                             | x    | x           |
| `shell`           | `bash-language-server`, `shellcheck`              | x    | x           |
| `terraform`       | `terraform`, `terraform-ls`, `tflint`             |      | x           |
| `uv`              | `uv`                                              | x    | x           |

Some tools are always installed regardless of selection due to their usefulness and usage: `age`, `cosign`, `node` 24, `sops`, `usage`.
