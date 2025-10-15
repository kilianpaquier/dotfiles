#!/bin/sh

set -e

if [ "$(whoami)" = "root" ]; then
  echo "bootstrap shouldn't be run as 'root'"
  exit 2
fi

# install various tools
sudo apt -y update
sudo apt -y dist-upgrade
sudo apt -y install bash-completion ca-certificates curl file git gnupg imagemagick jq make man rsync slirp4netns tree uidmap unzip vim wget zsh
sudo apt -y autoremove

# install z4h
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

# setup default git configuration
git config --global core.editor 'code --wait'
git config --global init.defaultbranch main
git config --global push.autoSetupRemote true

# setup ssh commit signatures
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
git config --global tag.gpgsign true

# mkdir -p "$HOME/workspaces/github.com/kilianpaquier"
# (
#   cd "$HOME/workspaces/github.com/kilianpaquier"
#   curl "https://api.github.com/users/kilianpaquier/repos?page=1&per_page=100" | jq -r '.[] | select(.fork == false and .archived == false) | .ssh_url' | xargs -L1 git clone
# )

# mkdir -p "$HOME/workspaces/gitlab.com/kilianpaquier"
