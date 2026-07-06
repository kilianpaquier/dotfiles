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
sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b $HOME/.local/bin init --branch feat/chezmoi --apply https://gitlab.com/kilianpaquier/dotfiles.git
```

```ps1
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --branch 'feat/chezmoi' --apply 'https://gitlab.com/kilianpaquier/dotfiles.git'"
```

In case you'd want to change your initial responses to prompts:

```sh
chezmoi init --prompt
```

## Prompts

| Key             | Type        | OS          | Default  | When                    | Description                                           |
| --------------- | ----------- | ----------- | -------- | ----------------------- | ----------------------------------------------------- |
| `dev`           | bool        | non-windows | `false`  |                         | Development machine (enables git, mise, agents, IDE)  |
| `profile`       | choice      | all         |          |                         | Work profile: `home` or `soprasteria`                 |
| `gaming`        | bool        | windows     | `false`  | `profile` == `home`     | Gaming machine (installs EA, Epic, Steam, Ubisoft...) |
| `shell`         | choice      | non-windows | `bash`   |                         | Shell to configure: `bash` or `zsh`                   |
| `ide`           | multichoice | all         | `vscode` |                         | IDEs in use: `intellij`, `vscode`, `zed`              |
| `ssh.generate`  | bool        | all         | `false`  |                         | Generate an SSH key (`id_ed25519`)                    |
| `computer_name` | string      | all         | hostname | `ssh.generate`          | Computer name (used in the SSH key comment)           |
| `user.email`    | string      | all         |          | `dev` or `ssh.generate` | Committer email address                               |
| `user.username` | string      | all         |          | `dev` or `ssh.generate` | Username                                              |
| `git.ssh`       | bool        | all         | `false`  | `dev`                   | Sign commits with SSH key                             |
| `agents`        | multichoice | all         |          | `dev`                   | AI agents to configure: `claude`, `copilot`           |
| `mise`          | bool        | all         | `false`  | `dev`                   | Use mise to manage tools                              |
