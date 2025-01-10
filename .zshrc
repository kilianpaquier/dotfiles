DOTFILES_CONFIG="$HOME/.config/dotfiles/dotfiles.env"
source "$DOTFILES_CONFIG"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
: ${INSTALL_DIR:="$HOME/.local"}
export PATH="$PATH:$INSTALL_DIR/bin"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="pure"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# SSH
zstyle ':omz:plugins:ssh-agent' identities id_ed25519 id_rsa
# zstyle ':omz:plugins:ssh-agent' lazy yes
zstyle ':omz:plugins:ssh-agent' quiet yes
# zstyle ':omz:plugins:ssh-agent' ssh-add-args -o AddKeysToAgent=yes

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(craft docker-rootless mise ssh-agent zsh-autosuggestions)
# plugins+=(bun gpg-agent jfrog)

source $ZSH/oh-my-zsh.sh

# User configuration

alias k='kubectl'
