# dotfiles <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fdotfiles?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

- [Prerequisites](#prerequisites)
- [Linking](#linking)
- [AI](#ai)
- [Additional configurations](#additional-configurations)
  - [Various git configurations](#various-git-configurations)
  - [Signing commits](#signing-commits)

## Prerequisites

Before being able to correctly use my dotfiles repository, basic utilities must be installed on your Linux OS.

```sh
sudo apt -y update
sudo apt -y dist-upgrade
sudo apt -y install bash-completion ca-certificates curl file git gnupg jq make man tree unzip vim wget zsh
sudo apt -y autoremove
```

Since my dotfiles is using [**`z4h`**](https://github.com/romkatv/zsh4humans),
this ZSH framework must also be installed before being able to use my dotfiles.

```sh
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
```

## Linking

Once all prerequisites are installed, time to clone the dotfiles repository and link 'rc' files.

```sh
git clone --recurse-submodules git@gitlab.com:kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/link.sh"
```

```sh
git clone --recurse-submodules https://gitlab.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/link.sh"
```

## AI

Since AI seems to be the go-to nowadays, you may want to follow at least some basic practices regarding how it will develop on your projects.
For that I setup'ed my own global instructions based on my own way of developing.

Same as linking the dotfiles, a specific link script can be executed to add symlinks in `$HOME/.claude` and `$HOME/.copilot`.

```sh
"$HOME/.dotfiles/link.ai.sh"
```

Note: Those instructions are likely to evolve and enriched throughout what **Claude** will miss on my own projects.

## Additional configurations

### Various git configurations

```sh
git config --global core.editor 'code --wait'
git config --global init.defaultbranch main
git config --global push.autoSetupRemote true
```

### Signing commits

With SSH or GPG:

```sh
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
git config --global tag.gpgsign true
```

```sh
git config --global --unset gpg.format
git config --global commit.gpgsign true
git config --global tag.gpgsign true
git config --global user.signingkey '<GPG KEY ID>'
gpg --list-secret-keys --keyid-format=long
```
