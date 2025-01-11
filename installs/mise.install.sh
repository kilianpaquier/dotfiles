#!/bin/sh

: "${INSTALL_DIR:="$HOME/.local"}"

mise_confd="$HOME/.config/mise/conf.d"
mkdir -p "$mise_confd"
# shellcheck disable=SC2154
ln -sf "$dotfiles_dir/installs/config/mise.dotfiles.toml" "$mise_confd/mise.dotfiles.toml"

if ! has mise; then
    log_info "Installing mise ..."
    download https://mise.run | MISE_INSTALL_PATH="$INSTALL_DIR/bin/mise" sh
else
    log_info "Updating mise dependencies ..."
    mise self-update && mise upgrade
fi
