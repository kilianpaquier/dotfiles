#!/bin/sh

if [ -z "$INSTALL_DIR" ]; then
  log_warn "Environment variable 'INSTALL_DIR' isn't defined, skipping mise installation"
  return
fi

mise_confd="$HOME/.config/mise/conf.d"
mkdir -p "$mise_confd"
# shellcheck disable=SC2154
ln -sf "$dir/installs/config/mise.dotfiles.toml" "$mise_confd/mise.dotfiles.toml"

if ! has mise; then
  log_info "Installing mise ..."
  download https://mise.run | MISE_INSTALL_PATH="$INSTALL_DIR/mise" sh
else
  log_info "Updating mise dependencies ..."
  mise self-update && mise upgrade
fi