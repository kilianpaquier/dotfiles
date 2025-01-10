# Pure theme styling
zmodload zsh/nearcolor
zstyle ':prompt:pure:git:stash' show yes
zstyle ':prompt:pure:user' color green
zstyle ':prompt:pure:host' color green
zstyle ':prompt:pure:path' color cyan

# Setup pure (https://github.com/sindresorhus/pure)
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
