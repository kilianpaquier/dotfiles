#!/bin/sh

if [ -z "$BIN_DIR" ]; then
  log_warn "Environment variable 'BIN_DIR' isn't defined, skipping mise installation"
  return
fi

mise_confd="$HOME/.config/mise/conf.d"
mkdir -p "$mise_confd"
# shellcheck disable=SC2154
ln -sf "$dir/installs/config/mise.dotfiles.toml" "$mise_confd/mise.dotfiles.toml"

if ! has mise; then
  log_info "Installing mise ..."
  download https://mise.run | MISE_INSTALL_PATH="$BIN_DIR/mise" sh
elif skip; then
  # shellcheck disable=SC2154
  log_warn "Skipping mise update and its dependencies (last run was $last_run seconds ago)"
else
  log_info "Updating mise dependencies ..."
  mise self-update --silent && mise upgrade
fi