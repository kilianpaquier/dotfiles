#!/bin/zsh
# shellcheck disable=SC1071

# Don't start tmux.
# zstyle ':z4h:' start-tmux 'no'

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'no'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Download required plugins repositories before z4h initialization
repos=(
  kilianpaquier/zsh-plugins
  ohmyzsh/ohmyzsh
)
for repo in $repos; do z4h install "$repo"; done
unset repo repos

# Load required plugins synchronously before z4h initialization
plugins=(
  ohmyzsh/ohmyzsh/plugins/ssh-agent
  kilianpaquier/zsh-plugins/history
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Load plugins asynchronously after z4h initialization
plugins=(
  kilianpaquier/zsh-plugins/disk-cleanup
  kilianpaquier/zsh-plugins/docker-rootless
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/just-completion
  kilianpaquier/zsh-plugins/mise-completion
  kilianpaquier/zsh-plugins/release-sync
  kilianpaquier/zsh-plugins/task-completion
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins
