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

# shellcheck disable=SC1091
[ -f "$dir/env" ] && . "$dir/.env"
: "${INSTALL_DIR:="$HOME/.local/bin"}"
: "${INSTALL_SCRIPTS:="apt docker-rootless git-config.dotfiles mise"}"

log_success "Using following dotfiles configuration:"
log "INSTALL_DIR=$INSTALL_DIR"
log "INSTALL_SCRIPTS=$INSTALL_SCRIPTS"

cat << EOF > "$dir/.env"
INSTALL_DIR="$INSTALL_DIR"
INSTALL_SCRIPTS="$INSTALL_SCRIPTS"
EOF

##############################################
# Set up Z4H
##############################################

if [ -n "$Z4H" ]; then
  download https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install | sh
fi

if [ ! -f "$dir/.env.zsh" ]; then
cat << 'EOF' > "$dir/.env.zsh"
# some more ls aliases
alias ll='ls -l'
alias lla='ls -lart'
alias l='ls -CF'

alias k="kubectl"

read zenv < <(readlink -f "$0")
read dir < <(dirname "$zenv")

plugins=(evalcache mise craft go-builder-generator gitlab-storage-cleaner docker-rootless)
for plugin in $plugins; do
  z4h load "$dir/custom/plugins/$plugin"
done

plugins=(ssh-agent)
for plugin in $plugins; do
  z4h load "ohmyzsh/ohmyzsh/plugins/$plugin"
done
EOF
fi
ln -sf "$dir/.env.zsh" "$HOME/.env.zsh"

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

log_success "Installation done, close your terminal and reload it with zsh"
unset dir