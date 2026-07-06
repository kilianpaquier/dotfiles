#!/bin/sh

set -e

umask 022

if ! command -v zsh >/dev/null 2>&1; then
  sudo apt update
  sudo apt -y install zsh
fi

if [ ! -d "$HOME/.cache/zsh4humans/v5" ]; then
  sh -c "$(curl -fSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
