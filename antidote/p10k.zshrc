#!/bin/zsh
# shellcheck disable=SC1071

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache/zsh"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUGINDIR="$ZDOTDIR/plugins"

if [ ! -d "$ZDOTDIR/antidote" ]; then
  echo "Clone antidote ..."
  git clone --quiet --depth 1 --recursive --shallow-submodules https://github.com/mattmc3/antidote.git "$ZDOTDIR/antidote"
fi

zsh_plugins="$ZDOTDIR/.zsh_plugins"
if [ ! -f "$zsh_plugins.before.txt" ]; then
cat << 'EOF' > "$zsh_plugins.before.txt"
belak/zsh-utils path:prompt
romkatv/powerlevel10k

ohmyzsh/ohmyzsh path:plugins/ssh-agent

belak/zsh-utils path:completion
mroth/evalcache

# installation plugins
kilianpaquier/zsh-plugins path:mise
kilianpaquier/zsh-plugins path:docker-rootless
kilianpaquier/zsh-plugins path:fzf
EOF
fi

if [ ! -f "$zsh_plugins.after.txt" ]; then
cat << 'EOF' > "$zsh_plugins.after.txt"
kilianpaquier/zsh-plugins path:bash-aliases kind:defer
kilianpaquier/zsh-plugins path:git-alias kind:defer
kilianpaquier/zsh-plugins path:goenv kind:defer
kilianpaquier/zsh-plugins path:highlight-styles kind:defer
kilianpaquier/zsh-plugins path:misenv kind:defer

# zsh user experience
Aloxaf/fzf-tab kind:defer
zsh-users/zsh-autosuggestions kind:defer
zsh-users/zsh-completions kind:defer
zsh-users/zsh-history-substring-search kind:defer
zsh-users/zsh-syntax-highlighting kind:defer
EOF
fi

# Lazy-load antidote and generate the static load file only when needed
if [[ ! "$zsh_plugins.before.zsh" -nt "$zsh_plugins.before.txt" ]]; then
  [ -n "$LOADED" ] || { source "$ZDOTDIR/antidote/antidote.zsh"; LOADED="1" }
  antidote bundle < "$zsh_plugins.before.txt" > "$zsh_plugins.before.zsh"
fi
source "$zsh_plugins.before.zsh"

# source p10k
[ -f "$ZDOTDIR/.zshrc" ] && source "$ZDOTDIR/.zshrc"

# Lazy-load antidote and generate the static load file only when needed
if [[ ! "$zsh_plugins.after.zsh" -nt "$zsh_plugins.after.txt" ]]; then
  [ -n "$LOADED" ] || { source "$ZDOTDIR/antidote/antidote.zsh"; LOADED="1" }
  antidote bundle < "$zsh_plugins.after.txt" > "$zsh_plugins.after.zsh"
fi
source "$zsh_plugins.after.zsh"
