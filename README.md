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
sh -c "$(curl -sSL https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch feat/chezmoi --apply https://gitlab.com/kilianpaquier/dotfiles.git
```

```ps1
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --branch 'feat/chezmoi' --apply 'https://gitlab.com/kilianpaquier/dotfiles.git'"
```

In case you'd want to change your initial responses to prompts:

```sh
chezmoi init --prompt
```

## Prompts

| Key                | Type        | OS          | Default                 | When                          | Description                                                                         |
| ------------------ | ----------- | ----------- | ----------------------- | ----------------------------- | ----------------------------------------------------------------------------------- |
| `dev`              | bool        | non-windows | `false`                 |                               | Development machine (enables git, mise, agents, IDE)                                |
| `profile`          | choice      | all         |                         |                               | Work profile: `home` or `soprasteria`                                               |
| `gaming`           | bool        | windows     | `false`                 | `profile` == `home`           | Gaming machine (installs EA, Epic, Steam, Ubisoft...)                               |
| `shell`            | choice      | non-windows | `bash`                  |                               | Shell to configure: `bash` or `zsh`                                                 |
| `ide`              | multichoice | all         | `vscode`                |                               | IDEs in use: `intellij`, `vscode`, `zed`                                            |
| `ssh.generate`     | bool        | all         | `false`                 |                               | Generate an SSH key (`id_ed25519`)                                                  |
| `machine_name`     | string      | all         | hostname                | `ssh.generate`                | Computer name (used in the SSH key comment)                                         |
| `user.email`       | string      | all         |                         | `dev` or `ssh.generate`       | Committer email address                                                             |
| `user.username`    | string      | all         |                         | `dev` or `ssh.generate`       | Username                                                                            |
| `git.ssh`          | bool        | all         | `false`                 | `dev`                         | Sign commits with SSH key                                                           |
| `ai.agents`        | multichoice | all         |                         | `dev`                         | AI agents to configure: `claude`, `codex`, `copilot`                                |
| `ai.plugins`       | multichoice | all         | `caveman`, `ponytail`   | `agents` non-empty            | Agent plugins to install: `caveman`, `ponytail`                                     |
| `tools_management` | multichoice | all         | `mise`, `node`          | `dev`                         | Tool manager(s) to use: `brew`, `mise`, `node`, `uv`. See [Tooling](#tooling) below |
| `tools.brew`       | multichoice | all         | see [Tooling](#tooling) | `tools_management` has `brew` | Tools to install with brew. See [Tooling](#tooling) below                           |
| `tools.mise`       | multichoice | all         | see [Tooling](#tooling) | `tools_management` has `mise` | Tools to install with mise. See [Tooling](#tooling) below                           |
| `tools.node`       | multichoice | all         | (empty)                 | `tools_management` has `node` | Tools to install with node (npm). See [Tooling](#tooling) below                     |
| `tools.uv`         | multichoice | all         | (empty)                 | `tools_management` has `uv`   | Tools to install with uv (pip). See [Tooling](#tooling) below                       |

## Tooling

Dev tools are installed through one or more managers, selected via `tools_management`: `brew`, `mise`, `node`, `uv`.
- `apm` (AI agent tooling) is automatic whenever `agents` is non-empty, no manager choice needed.
- `node` as a manager needs `brew` or `mise` to actually provide the `node` binary, so pick at least one of those alongside it.
- `uv` as a manager needs `brew` or `mise` to actually provide the `uv` binary, so pick at least one of those alongside it.

### Cross-manager exclusivity

Managers are prompted in order: `mise`, then `brew`, then `node`, then `uv`.
Once a tool is picked under an earlier manager, it's removed from the choices offered to the later ones, so the same tool never installs twice.

### Available tools per manager

| Manager | Available tools                                                                                                                                                                                                                |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| brew    | `bun`, `git-tools`, `go`, `hugo`, `incus`, `java`, `just`, `k6`, `k8s`, `kotlin`, `opentofu`, `rtk`, `shell`, `task`, `terraform`, `typescript`, `uv`                                                                          |
| mise    | `bun`, `codebase-memory-mcp`, `codegraph`, `context7`, `git-tools`, `go`, `graphify`, `hugo`, `incus`, `java`, `just`, `k6`, `k8s`, `kotlin`, `mempalace`, `opentofu`, `rtk`, `shell`, `task`, `terraform`, `typescript`, `uv` |
| node    | `bun`, `cavemem`, `context7`, `hugo`, `pnpm`, `shell`, `task`, `typescript`, `yarn`                                                                                                                                            |
| uv      | `graphify`, `just`, `mempalace`                                                                                                                                                                                                |
