#!/bin/sh

mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/pure" ]; then
  log_info "Cloning pure prompt ..."
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi
log_info "Updating pure prompt ..."
(cd "$HOME/.zsh/pure" && git pull)
