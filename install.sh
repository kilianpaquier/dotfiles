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
dotfiles_dir="$(realpath "$(dirname "$0")")"

log_info "Updating dotfiles ..."
(
  cd "$dotfiles_dir" || exit 1
  if [ "$(git status --porcelain | wc -l)" -eq 0 ]; then git pull; else log_warn "Changes detected in $(pwd) not pulling dotfiles ..."; fi
  log_info "Updating oh-my-zsh plugins ..."
  git submodule update --recursive --remote
)

if [ ! -f "$dotfiles_dir/.env" ]; then
  log_info "Setting up default dotfiles config in $dotfiles_dir/.env ..."
  cp "$dotfiles_dir/default.env" "$dotfiles_dir/.env"
fi
log_success "Using following dotfiles configuration:"
log "$(cat "$dotfiles_dir/.env")"
# shellcheck disable=SC1091
. "$dotfiles_dir/.env"

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"

if [ ! -d "$ZSH" ]; then
  log_info "Installing oh-my-zsh ..."
  download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | ZSH="$ZSH" sh
fi

log_info "Updating default .zshrc templates ..."
download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/templates/zshrc.zsh-template >"$dotfiles_dir/templates/.zshrc"
download https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/templates/minimal.zshrc >"$dotfiles_dir/templates/minimal.zshrc"

log_info "Setting up .zshrc symbolic link ..."
ln -sf "$dotfiles_dir/.zshrc" "$HOME/.zshrc"
ln -sf "$dotfiles_dir/aliases.dotfiles.zsh" "$ZSH_CUSTOM/aliases.dotfiles.zsh"

# INSTALLS comes from $dotfiles_dir/.env
# shellcheck disable=SC2154
for install in $INSTALLS; do
  target="$dotfiles_dir/installs/$install.install.sh"
  log_info "Running installation script $target ..."
  # source install file instead of run to get all current environment variables
  # shellcheck disable=SC1090
  [ -f "$target" ] && . "$target"
done
unset dotfiles_dir

# ZSH_CUSTOMS comes from $dotfiles_dir/.env
# shellcheck disable=SC2153
for custom in $ZSH_CUSTOMS; do
  log_info "Creating symbolic links for $custom ..."
  [ -d "$custom" ] || continue

  for item in "$custom"/*; do
    # handle symbolic links between subdirs
    if [ -d "$item" ]; then
      for subitem in "$item"/*; do
        target="$ZSH_CUSTOM/$(basename "$item")/$(basename "$subitem")"
        log "Setting up $subitem symbolic link with $target ..."
        rm "$target" && ln -s "$subitem" "$target"
      done
    fi

    # handle symbolic links between files
    if [ -f "$item" ]; then
      target="$ZSH_CUSTOM/$(basename "$item")"
      log "Setting up $item symbolic link with $target ..."
      ln -sf "$item" "$ZSH_CUSTOM/$(basename "$item")"
    fi
  done
done

log_success "Installation done, close your terminal and reload it or run 'omz reload'"