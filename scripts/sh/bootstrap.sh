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

# if [ ! -d "$HOME/.dotfiles" ]; then
#   git clone https://gitlab.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles"
# fi

# setup default git configuration
git config --global core.editor 'code --wait'
git config --global init.defaultbranch main
git config --global push.autoSetupRemote true

# setup ssh commit signatures
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
git config --global tag.gpgsign true

# install z4h
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

# mkdir -p "$HOME/workspaces/gitlab.com/kilianpaquier"
# (
#   cd "$HOME/workspaces/gitlab.com/kilianpaquier"
#   curl "https://gitlab.com/api/v4/groups/kilianpaquier/projects?per_page=100" | \
#     jq -r '.[] | select(.forked_from_project == null and .archived == false) | .ssh_url_to_repo' | \
#     xargs -L1 git clone
# )

# mkdir -p "$HOME/workspaces/gitlab.com/kickr-dev"
# (
#   cd "$HOME/workspaces/gitlab.com/kickr-dev"
#   curl "https://gitlab.com/api/v4/groups/kickr-dev/projects?per_page=100" | \
#     jq -r '.[] | select(.forked_from_project == null and .archived == false) | .ssh_url_to_repo' | \
#     xargs -L1 git clone
# )
