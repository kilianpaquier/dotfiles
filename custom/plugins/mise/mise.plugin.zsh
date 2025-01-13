if (( ! $+commands[mise] )); then return; fi
eval "$(mise activate zsh)"

if [[ ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi

mise completion zsh >! "$ZSH_CACHE_DIR/completions/_mise" &|