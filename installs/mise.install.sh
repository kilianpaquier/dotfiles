#!/bin/sh

: "${INSTALL_DIR:="$HOME/.local"}"

if ! has mise; then
    log_info "Installing mise ..."
    download https://mise.run | MISE_INSTALL_PATH="$INSTALL_DIR/bin/mise" sh
else
    log_info "Updating mise dependencies ..."
    mise self-update && mise upgrade
fi
