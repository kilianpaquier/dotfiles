# .env.zsh (for z4h)

# Download required plugins repositories before z4h initialization
repos=(
  kilianpaquier/zsh-plugins
  mroth/evalcache
  ohmyzsh/ohmyzsh
)
for repo in $repos; do z4h install "$repo"; done
unset repo repos

# Load required plugins synchronously before z4h initialization
plugins=(
  ohmyzsh/ohmyzsh/plugins/ssh-agent

  kilianpaquier/zsh-plugins/mise
  kilianpaquier/zsh-plugins/docker-rootless
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
  mroth/evalcache

  kilianpaquier/zsh-plugins/bash-aliases
  kilianpaquier/zsh-plugins/git-aliases
  kilianpaquier/zsh-plugins/goenv
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/misenv
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins
