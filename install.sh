#!/bin/sh

set -e

SCRIPT_DIR="$(dirname "$0")"

for file in "$SCRIPT_DIR"/scripts/sh/*.sh; do
    # shellcheck disable=SC1090
    . "$file"
done

default_apt && auto_remove

log_info "Updating dotfiles ..."
mkdir -p "$HOME/.ssh"
(
    cd "$HOME/.dotfiles" || exit 1
    if [ "$(git status --porcelain | wc -l)" -eq 0 ]; then
        git pull
    else
        log_warn "Changes detected in $HOME/.dotfiles, not pulling dotfiles ..."
    fi
)

log_info "Updating oh-my-zsh plugins ..."
git submodule update --recursive --remote

mkdir -p "$HOME/.zsh"
if [ -d "$HOME/.zsh/pure" ]; then
    log_info "Updating pure prompt ..."
    (cd "$HOME/.zsh/pure" && git pull)
else
    log_info "Cloning pure prompt ..."
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing oh-my-zsh ..."
    download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
fi

log_info "Setting up .zshrc symbolic link ..."
ln -sf "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
