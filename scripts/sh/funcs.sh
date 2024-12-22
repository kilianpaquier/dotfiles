#!/bin/sh

has() {
    which "$1" > /dev/null 2>&1
}

download() {
    if has curl; then
        curl -fsSL "$1"
    else
        wget -qO- "$1"
    fi
}

check_install_dir() {
    if [ -n "$INSTALL_DIR" ]; then
        [ -d "$INSTALL_DIR/bin" ] || mkdir -p "$INSTALL_DIR/bin"
    else
        log_error "Installation dir is undefined." && return 1
    fi
}

auto_remove() {
    has apt || return 0
    log_info "Auto uninstalling unnecessary dependencies ..." && sudo apt autoremove -y
}

default_apt() {
    has apt || return 0

    log_info "Upgrading current dependencies and distribution ..."
    sudo apt update -y && sudo apt dist-upgrade -y

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt install -y autojump bash-completion ca-certificates curl file git gnupg jq keychain make man rsync tree uidmap unzip vim wget zsh
    # sudo apt install openjdk-17-jdk maven redis-server
}

install_from_github() {
    check_install_dir

    repository="$1"
    current_version="$2"
    asset="$3"
    tar_opts="$([ -n "$4" ] && echo "$4" || echo -xz)"

    log_info "Checking $repository releases ..."

    name=$(basename "$repository")
    new_version=$(download "https://api.github.com/repos/$repository/releases/latest" | jq -r '.tag_name') # FIXME authentication to avoid rate limit
    download_dir="/tmp/$repository/$new_version"

    if echo "$current_version" | grep -Eq "${new_version#v*}"; then
        log_info "Latest $repository version $new_version already installed"
        return 0
    fi
    final_asset=$(echo "$asset" | sed "s/{{version}}/${new_version#v*}/g")
    url="https://github.com/$repository/releases/download/$new_version/$final_asset"

    log_info "Installing $repository version $new_version from $url"

    rm -rf "$download_dir" && mkdir -p "$download_dir"
    # shellcheck disable=SC2086
    download "$url" | (cd "$download_dir" && tar $tar_opts)
    chmod +x "$download_dir/$name" && cp "$download_dir/$name" "$INSTALL_DIR/bin/$name"
}