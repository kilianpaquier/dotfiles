if (( ! $+commands[gitlab-storage-cleaner] )); then return; fi

if [ ! -f "$ZSH_CACHE_DIR/completions/_gitlab-storage-cleaner" ]; then
  typeset -g -A _comps
  autoload -Uz _gitlab-storage-cleaner
  _comps[gitlab-storage-cleaner]=_gitlab-storage-cleaner
fi

gitlab-storage-cleaner completion zsh >! "$ZSH_CACHE_DIR/completions/_gitlab-storage-cleaner" &|