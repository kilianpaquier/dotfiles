#!/bin/sh

log() {
  echo "$1"
}

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
  echo "${fg}$1${reset}" >&2
}

log_error() {
  fg="\033[0;31m"
  reset="\033[0m"
  echo "${fg}$1${reset}" >&2
}

has() {
  which "$1" >/dev/null 2>&1
}

download() {
  if has curl; then curl -fsSL "$1"; else wget -qO- "$1"; fi
}

set -e
dir="$(realpath "$(dirname "$0")")"

##############################################
# Updating dotfiles
##############################################

log_info "Updating dotfiles ..."
(
  cd "$dir" || exit 1
  if [ "$(git status --porcelain | wc -l)" -eq 0 ]; then git pull; else log_warn "Changes detected in $(pwd) not pulling dotfiles ..."; fi
  log_info "Updating submodules ..."
  git submodule update --init --recursive --remote
)

##############################################
# Set up default .env file and source it
##############################################

if [ ! -f "$dir/.env" ]; then
  log_info "Setting up default dotfiles config in $dir/.env ..."
  cp "$dir/default.env" "$dir/.env"
fi
log_success "Using following dotfiles configuration:"
log "$(cat "$dir/.env")"
# shellcheck disable=SC1091
. "$dir/.env"

##############################################
# Set up Oh My Zsh
##############################################

ZSH="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH" ]; then
  log_info "Installing oh-my-zsh ..."
  download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | ZSH="$ZSH" sh
fi

log_info "Updating default .zshrc templates ..."
download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/templates/zshrc.zsh-template >"$dir/templates/.zshrc"
download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/templates/minimal.zshrc >"$dir/templates/minimal.zshrc"

##############################################
# Set up symbolic link between .zshrc
##############################################

[ -L "$dir/.zshrc" ] || (log_info "Setting up .zshrc symbolic link ..." && ln -sf "$dir/.zshrc" "$HOME/.zshrc")

##############################################
# Iterate over installation scripts
# and source them (to get env variables)
##############################################

# INSTALL_SCRIPTS comes from $dir/.env
# shellcheck disable=SC2154
for install in $INSTALL_SCRIPTS; do
  target="$dir/installs/$install.install.sh"
  log_info "Running installation script $target ..."
  # shellcheck disable=SC1090
  [ -f "$target" ] && . "$target"
done

log_success "Installation done, close your terminal and reload it or run 'omz reload'"
unset dir