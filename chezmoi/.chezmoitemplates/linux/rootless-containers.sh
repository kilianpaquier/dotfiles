# shellcheck shell=sh

# uidmap provides newuidmap/newgidmap, needed by rootless docker's user namespace
install_uidmap() {
  if ! grep -q "^$USER:" /etc/subuid 2>/dev/null || ! grep -q "^$USER:" /etc/subgid 2>/dev/null; then
    if ! command -v newuidmap >/dev/null 2>&1 || ! command -v newgidmap >/dev/null 2>&1; then
      pkg_install uidmap shadow-utils shadow
    fi
  fi
}

# rootless docker's systemd user service needs linger to start at boot and survive logout
enable_linger() {
  [ -d /run/systemd/system ] || {
    warn "systemd isn't running, skipping linger for rootless docker"
    return 0
  }

  if [ "$(loginctl show-user "$USER" -p Linger --value 2>/dev/null)" != "yes" ]; then
    # a cancelled or repeatedly-wrong sudo prompt must not abort the rest of the setup
    trap ':' INT
    sudo loginctl enable-linger "$USER" || warn "failed to enable linger for rootless docker, skipping"
    trap - INT
  fi
}

install_uidmap
enable_linger
