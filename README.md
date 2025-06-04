<!-- This file is safe to edit. Once it exists it will not be overwritten. -->

# dotfiles <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/dotfiles?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/dotfiles?style=for-the-badge">
</p>

---

- [Debian](#debian)
  - [Prerequisites](#prerequisites)
  - [Link dotfiles](#link-dotfiles)
  - [Plugin Managers](#plugin-managers)
- [Additional configurations](#additional-configurations)
  - [Various git configurations](#various-git-configurations)
  - [Signing commits](#signing-commits)

## Debian

### Prerequisites

Some useful (and for some required) dependencies, additionally it also updates the current machine:

```sh
sudo apt -y update
sudo apt -y dist-upgrade
sudo apt -y install bash-completion ca-certificates curl file git gnupg imagemagick jq make man rsync slirp4netns tree uidmap unzip vim wget zsh
sudo apt -y autoremove
```

### Link dotfiles

In any terminal (SSH or HTTPS depending on your needs):

```sh
git clone --recurse-submodules git@github.com:kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/link.sh"
```

```sh
git clone --recurse-submodules https://github.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/link.sh"
```

### Plugin Managers

#### Z4H

To use dotfiles with `z4h`, the zsh plugin must be installed **before linking `.zshrc`**, nothing to do in `.zshrc` since it's cloned with `z4h` defined:

```sh
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
```

#### Antidote

Antidote is cloned if needed in `.zshrc`, as such, the only thing to do is replace `.zshrc` with either `p10k` or `omz` prompting:

```sh
cat << 'EOF' > "$HOME/.zshrc"
# .zshrc

read me < <(readlink -f "$HOME/.zshrc")
read dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/antidote/p10k.zshrc"
EOF
```

```sh
cat << 'EOF' > "$HOME/.zshrc"
# .zshrc

read me < <(readlink -f "$HOME/.zshrc")
read dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/antidote/omz.zshrc"
EOF
```

#### Antidote lite

Antidote lite is curl'ed if needed in `.zshrc`, as such, the only thing to do is replace `.zshrc` with either `p10k` or `omz` prompting:

```sh
cat << 'EOF' > "$HOME/.zshrc"
# .zshrc

read me < <(readlink -f "$HOME/.zshrc")
read dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/antidote.lite/p10k.zshrc"
EOF
```

```sh
cat << 'EOF' > "$HOME/.zshrc"
# .zshrc

read me < <(readlink -f "$HOME/.zshrc")
read dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/antidote.lite/omz.zshrc"
EOF
```

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
