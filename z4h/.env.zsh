# .env.zsh (for z4h)

# Make sure to disable p10k to play with PS1
# zstyle ':z4h:powerlevel10k' channel 'none'
# RPS1="" # remove "z4h recovery mode"

# See all substitution with zsh at https://linux.die.net/man/1/zshmisc

# Default PS1
# PS1="%B%F{2}%n@%m%f %F{4}%~%f
# %F{%(?.2.1)}%#%f%b "

# %B%F{2}%n@%m%f = name@host (green)

# %F{4}%~%f = ~pwd (blue)
# %F{4}%3~%f = ~pwd (last three dirs) (blue)

# %F{%(?.2.1)}%#%f%b = % or # (shell sudo or not) (green or red depending on previous command result)

# PS1="%F{2}%n@%m%f %F{4}%3~%f %F{%(?.2.1)}%(!.#.$)%f "

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
  kilianpaquier/zsh-plugins/bash-aliases
  kilianpaquier/zsh-plugins/git-aliases
  kilianpaquier/zsh-plugins/goenv
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/mise-completion
  kilianpaquier/zsh-plugins/mise-shims
)
for plugin in $plugins; do z4h load "$plugin"; done
unset plugin plugins
