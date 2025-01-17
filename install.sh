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
# Updating
##############################################

log_info "Updating ..."
(
  cd "$dir" || exit 1
  if [ "$(git status --porcelain | wc -l)" -eq 0 ]; then
    sha=$(git rev-parse HEAD)
    git pull
    if [ "$(git rev-parse HEAD)" != "$sha" ]; then
      log_warn "Changes were pulled, rerunning script"
      $0 "$@"
      exit $?
    fi
  else
    log_warn "Changes detected in $(pwd) not pulling dotfiles ..."
  fi
  log_info "Updating submodules ..."
  git submodule update --init --recursive --remote
)

##############################################
# Set up default .env file and source it
##############################################

log_info "Loading .env ..."

# shellcheck disable=SC1091
[ -f "$dir/.env" ] && . "$dir/.env" && rm "$dir/.env"

if [ -z "$BIN_DIR" ]; then BIN_DIR="$HOME/.local/bin"; else echo "BIN_DIR=\"$BIN_DIR\"" >> "$dir/.env"; fi
log "BIN_DIR=$BIN_DIR"

if [ -z "$INSTALL_SCRIPTS" ]; then
  echo "$dir/installs/"*.install.sh
  for script in "$dir/installs/"*.install.sh; do
    INSTALL_SCRIPTS="$INSTALL_SCRIPTS $(basename "$script" .install.sh)"
  done
else
  echo "INSTALL_SCRIPTS=\"$INSTALL_SCRIPTS\"" >> "$dir/.env"
fi
log "INSTALL_SCRIPTS=$INSTALL_SCRIPTS"

##############################################
# Set up default .env.zsh file and source it
##############################################

if [ ! -f "$dir/.env.zsh" ]; then
cat << 'EOF' > "$dir/.env.zsh"
read me < <(readlink -f "$0")
read dir < <(dirname "$me")

fpath+=($dir/custom/autoloaded)

plugins=(evalcache mise goenv craft go-builder-generator gitlab-storage-cleaner docker-rootless)
for plugin in $plugins; do z4h load "$dir/custom/plugins/$plugin"; done

plugins=(ssh-agent)
for plugin in $plugins; do z4h load "ohmyzsh/ohmyzsh/plugins/$plugin"; done

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=green" # remove underline
ZSH_HIGHLIGHT_STYLES[path]=none # remove underline
ZSH_HIGHLIGHT_STYLES[precommand]="fg=green" # remove underline
ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=green" # remove underline

# some more ls aliases
alias ll='ls -l'
alias lla='ls -lart'
alias l='ls -CF'

alias k='kubectl'
EOF
fi
ln -sf "$dir/.env.zsh" "$HOME/.env.zsh"
ln -sf "$HOME/.zshrc" "$dir/.zshrc"

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