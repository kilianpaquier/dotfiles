#!/bin/sh

if has apt; then
    log_info "Upgrading current dependencies and distribution ..."
    sudo apt -yqq update && sudo apt -yqq dist-upgrade

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt -yqq install bash-completion ca-certificates curl file git gnupg jq make man rsync tree uidmap unzip vim wget zsh
    # sudo apt install openjdk-17-jdk maven redis-server

    log_info "Auto uninstalling unnecessary dependencies ..."
    sudo apt -yqq autoremove
fi