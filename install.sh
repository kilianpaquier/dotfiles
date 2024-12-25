#!/bin/sh

set -e

: "${INSTALL_DIR:="$HOME/.local"}"

SCRIPT_DIR="$(dirname "$0")"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/scripts/sh/funcs.sh"

if ! has apt; then
    log_error "Apt is required for .dotfiles to work properly."
    exit 2
fi

if has apt; then
    log_info "Upgrading current dependencies and distribution ..."
    sudo apt update -y && sudo apt dist-upgrade -y

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt install -y bash-completion ca-certificates curl file git gnupg jq keychain make man rsync tree uidmap unzip vim wget zsh
    # sudo apt install openjdk-17-jdk maven redis-server

    log_info "Auto uninstalling unnecessary dependencies ..."
    sudo apt autoremove -y
fi

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

if ! has mise; then
    log_info "Installing mise ..."
    check_install_dir
    download https://mise.run | MISE_INSTALL_PATH="$INSTALL_DIR/bin/mise" sh
else
    log_info "Updating mise dependencies ..."
    mise upgrade
fi

if ! has docker; then
    log_info "Installing docker ..."
    download https://get.docker.com | sh

    # rootless configuration
    log_info "Setting up docker rootless ..."
    dockerd-rootless-setuptool.sh install
fi

git_config