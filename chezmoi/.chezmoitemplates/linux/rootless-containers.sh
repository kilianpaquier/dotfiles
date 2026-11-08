# shellcheck shell=sh

# uidmap provides the setuid newuidmap/newgidmap, needed by rootless docker's user namespace
install_uidmap() {
  if ! pkg_install uidmap shadow-utils shadow; then
    warn "uidmap is missing, install uidmap (apt), shadow-utils (dnf) or shadow (pacman) as root"
  fi

  if ! grep -q "^$USER:" /etc/subuid 2>/dev/null || ! grep -q "^$USER:" /etc/subgid 2>/dev/null; then
    # the fixed range is only safe while no user holds one
    if [ -s /etc/subuid ] || [ -s /etc/subgid ] || ! sudo_run usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"; then
      warn "$USER has no subuid or subgid entry, run as root: usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER"
    fi
  fi
}

# rootless docker's systemd user service needs linger to start at boot and survive logout
enable_linger() {
  [ -d /run/systemd/system ] || {
    warn "systemd isn't running, skipping linger for rootless docker"
    return 0
  }

  if [ "$(loginctl show-user "$USER" -p Linger --value 2>/dev/null)" = "yes" ]; then
    return 0
  fi

  if ! sudo_run loginctl enable-linger "$USER"; then
    warn "linger is off, run as root: loginctl enable-linger $USER"
  fi
}

install_uidmap
enable_linger
