zstyle :omz:plugins:keychain options --quiet --ignore-missing
zstyle :omz:plugins:keychain agents gpg,ssh
zstyle :omz:plugins:keychain identities id_ed25519 id_rsa

zmodload zsh/nearcolor
zstyle :prompt:pure:git:stash show yes
zstyle ':prompt:pure:user' color green
zstyle ':prompt:pure:host' color green
zstyle ':prompt:pure:path' color cyan
# zstyle ':prompt:pure:prompt:*' color magenta

alias g='git'
alias h='helm'
alias k='kubectl'
alias setup="$ZSH_CUSTOM/cli.sh"
alias update="$ZSH_CUSTOM/install.sh"

export DOCKER_HOST="unix:///run/user/1000/docker.sock"
export PATH="$PATH:$HOME/.local/bin"

export GOBIN="$HOME/go/bin"
export PATH="$PATH:$GOBIN"