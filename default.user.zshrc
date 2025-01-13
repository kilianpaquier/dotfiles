export MISE_PARANOID=1 # force HTTPS
# export MISE_DISABLE_BACKENDS="asdf"

ZSH_THEME="pure"
CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"

zstyle ':omz:update' mode reminder

zstyle ':omz:plugins:ssh-agent' identities id_ed25519 id_rsa
zstyle ':omz:plugins:ssh-agent' quiet yes

plugins+=(mise craft gitlab-storage-cleaner go-builder-generator zsh-autosuggestions)
plugins+=(ssh-agent)
