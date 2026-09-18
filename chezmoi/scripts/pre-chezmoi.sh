#!/bin/sh

set -e

# ansible-core alone ships no community.general / ansible.posix, the ansible meta package does
if [ "$(dpkg-query -W -f='${Status}' ansible 2>/dev/null)" != "install ok installed" ]; then
  sudo apt update
  sudo apt -y install ansible
fi
sudo -v
