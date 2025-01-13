if (( ! $+commands[craft] )); then return; fi

if [ ! -f "$ZSH_CACHE_DIR/completions/_craft" ]; then
  typeset -g -A _comps
  autoload -Uz _craft
  _comps[craft]=_craft
fi

craft completion zsh >! "$ZSH_CACHE_DIR/completions/_craft" &|