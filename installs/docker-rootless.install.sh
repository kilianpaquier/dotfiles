#!/bin/sh

if ! has docker; then
  log_info "Installing docker ..."
  download https://get.docker.com | sh

  # rootless configuration
  log_info "Setting up docker rootless ..."
  dockerd-rootless-setuptool.sh install
fi
