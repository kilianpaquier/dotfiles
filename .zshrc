export MISE_PARANOID=1 # force HTTPS
# export MISE_DISABLE_BACKENDS="asdf"

export INSTALL_DIR="$HOME/.local"
export PATH="$PATH:$INSTALL_DIR/bin"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="pure"
CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"

zstyle ':omz:update' mode reminder

zstyle ':omz:plugins:ssh-agent' identities id_ed25519 id_rsa
zstyle ':omz:plugins:ssh-agent' quiet yes

plugins=(docker-rootless mise ssh-agent zsh-autosuggestions)
# plugins+=(bun gpg-agent jfrog)

source $ZSH/oh-my-zsh.sh
