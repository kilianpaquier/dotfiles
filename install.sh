#!/bin/sh

log_success() {
    fg="\033[0;32m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_info() {
    fg="\033[0;34m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_warn() {
    fg="\033[0;33m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_error() {
    fg="\033[0;31m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

set -e

if [ "$(uname -o)" = "GNU/Linux" ]; then
    log_info "Upgrading current dependencies and distribution ..."
    sudo apt update -y && sudo apt dist-upgrade -y

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt install -y autojump bash-completion ca-certificates curl file git gnupg jq keychain make man rsync tree uidmap unzip vim wget zsh

    log_info "Auto uninstalling unnecessary dependencies ..."
    sudo apt autoremove -y
fi

log_info "Updating or cloning dotfiles project ..."
mkdir -p "$HOME/.ssh"
if [ -d "$HOME/.dotfiles" ]; then
    (
        cd "$HOME/.dotfiles"
        ([ "$(git status --porcelain | wc -l)" -eq 0 ] && git pull && git submodule update --recursive --remote) || log_warn "Changes detected in $HOME/.dotfiles, not pulling project ..."
    )
elif [ -n "$HTTP_CLONE" ] || [ "$(find "$HOME/.ssh" -maxdepth 1 ! -name '*.*' -name 'id_*' | wc -l)" -eq 0 ]; then
    git clone --recurse-submodules https://github.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles"
else
    git clone --recurse-submodules git@github.com:kilianpaquier/dotfiles.git "$HOME/.dotfiles"
fi

log_info "Updating or cloning pure prompt ..."
mkdir -p "$HOME/.zsh"
([ -d "$HOME/.zsh/pure" ] && cd "$HOME/.zsh/pure" && git pull) || git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

log_info "Installing oh-my-zsh ..."
[ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

log_info "Setting up .zshrc symbolic link ..."
ln -sf "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
