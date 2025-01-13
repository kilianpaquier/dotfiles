if (( ! $+commands[go-builder-generator] )); then return; fi

if [ ! -f "$ZSH_CACHE_DIR/completions/_go-builder-generator" ]; then
  typeset -g -A _comps
  autoload -Uz _go-builder-generator
  _comps[go-builder-generator]=_go-builder-generator
fi

go-builder-generator completion zsh >! "$ZSH_CACHE_DIR/completions/_go-builder-generator" &|