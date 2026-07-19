#!/bin/sh

set -e

sudo apt update
sudo apt -y full-upgrade
sudo apt -y install bash-completion bubblewrap build-essential ca-certificates curl file gettext-base gnupg jq make man ripgrep socat tree unzip vim wget yq
sudo apt -y autoremove
