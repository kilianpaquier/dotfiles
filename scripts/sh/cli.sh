#!/bin/sh

#########################################################
# Bun
#########################################################

install_bun() {
    check_install_dir

    if has bun; then
        log_info "Upgrading bun ..."
        bun upgrade
    elif ! has bash; then
        log_error "Bash is required to install Bun."
        return 1
    else
        log_info "Installing bun ..."
        download https://bun.sh/install | BUN_INSTALL="$INSTALL_DIR" bash
    fi
}

#########################################################
# Docker
#########################################################

install_docker() {
    if has "docker"; then
        log_info "Docker is already installed."
        return 0
    fi

    log_info "Installing docker ..."
    download https://get.docker.com | sh

    # rootless configuration
    log_info "Setting up docker rootless ..."
    dockerd-rootless-setuptool.sh install
}

#########################################################
# Git
#########################################################

git_config() {
    if ! has git > /dev/null 2>&1; then
        log_error "Git is required to setup git configuration."
        return 1
    fi

    log_info "Setting up various git configuration globally ..."
    git config --global core.editor 'code --wait'
    git config --global init.defaultbranch main
    git config --global push.autoSetupRemote true

    git config --global core.pager 'cat'
    git config --global pager.diff 'less -FX'

    log_warn "Execute the following commands to setup git commit and tagging signatures with SSH:
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
git config --global tag.gpgsign true"

    git config --global --remove-section alias > /dev/null 2>&1 || true

    git config --global alias.alias '!git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /'
    git config --global alias.amend 'commit --amend --no-edit'
    git config --global alias.branches "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
    git config --global alias.c 'commit -m'
    git config --global alias.cp 'cherry-pick'
    git config --global alias.current 'rev-parse --abbrev-ref HEAD'
    git config --global alias.ls 'log --reverse'
    git config --global alias.last 'ls -1 HEAD --stat'
    git config --global alias.ll 'ls --oneline'
    # shellcheck disable=SC2016
    # git config --global alias.mad '!f() { git reset --hard ${1-origin/$(git current)}; }; f'
    # shellcheck disable=SC2016
    git config --global alias.mad 'reset --hard'
    git config --global alias.n 'checkout -b'
    git config --global alias.p 'push'
    git config --global alias.pf 'push --force-with-lease'
    # shellcheck disable=SC2016
    git config --global alias.purge '!git fetch -p && for branch in $(git for-each-ref --format '\''%(refname) %(upstream:track)'\'' refs/heads | awk '\''$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'\''); do git branch -D $branch; done'
    git config --global alias.r '!git fetch --all && git rebase'
    git config --global alias.rename 'commit --amend'
    git config --global alias.search '!git rev-list --all | xargs git grep -F'
    git config --global alias.undo 'reset HEAD~1 --mixed'
    git config --global alias.unstage 'reset HEAD --'
    # shellcheck disable=SC2016
    git config --global alias.vc '!cat ${HOME}/.gitconfig'
}

#########################################################
# Go
#########################################################

install_go() {
    check_install_dir

    log_info "Checking go releases ..."
    latest=$(download "https://go.dev/dl/?mode=json" | jq -r '.[0].version')
    (go version | grep -Eq "$latest") && log_info "Latest go version $latest already installed" && return 0

    download_dir="$INSTALL_DIR/share/go"
    rm -rf "$download_dir" && mkdir -p "$download_dir"
    download "https://go.dev/dl/$latest.linux-amd64.tar.gz" | (cd "$download_dir" && tar -xz --strip-components=1)

    for item in "$download_dir"/bin/*; do
        chmod +x "$item" && ln -sf "$item" "$INSTALL_DIR/bin/$(basename "$item")"
    done
}

install_golangci_lint() {
    check_install_dir

    log_info "Checking golangci-lint releases ..."
    download "https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh" | sh -s -- -b "$INSTALL_DIR/bin"
}

install_goreleaser() {
    install_from_github "goreleaser/goreleaser" "$(goreleaser --version || echo v0.0.0)" "goreleaser_Linux_x86_64.tar.gz"
}

install_gotools() {
    if ! has go; then
        log_error "Go is required to install go tools."
        return 1
    fi

    log_info "Installing govulncheck ..."
    go install golang.org/x/vuln/cmd/govulncheck@latest
}

install_hugo() {
    install_from_github "gohugoio/hugo" "$(hugo version || echo v0.0.0)" "hugo_extended_{{version}}_linux-amd64.tar.gz"
}

#########################################################
# Kubernetes
#########################################################

install_helm() {
    check_install_dir

    if ! has bash; then
        log_error "Bash is required to install helm."
        exit 1
    fi

    log_info "Installing Helm 3 ..."
    download "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | HELM_INSTALL_DIR="$INSTALL_DIR/bin" USE_SUDO="false" bash
}

install_kubectl() {
    check_install_dir

    log_info "Installing kubectl ..."
    new_version=$(download "https://dl.k8s.io/release/stable.txt")
    if shellcheck --version | grep -Eq "${new_version#v*}"; then
        log_info "Latest kubectl version already installed"
    else
        download "https://dl.k8s.io/release/$new_version/bin/linux/amd64/kubectl" -o "$INSTALL_DIR/bin/kubectl"
        chmod +x "$INSTALL_DIR/bin/kubectl"
    fi
}

install_k9s() {
    install_from_github "derailed/k9s" "$(k9s version || echo v0.0.0)" "k9s_Linux_amd64.tar.gz"
}

#########################################################
# Node
#########################################################

install_node() {
    if ! has apt; then
        log_error "apt is required to install Node."
        return 1
    fi

    NODE_MAJOR=22
    if node --version | grep -Eq "v$NODE_MAJOR"; then
        log_info "Node v$NODE_MAJOR is already installed."
        return 0
    fi

    keyring=/etc/apt/keyrings/nodesource.gpg
    source=/etc/apt/sources.list.d/nodesource.list
    url=https://deb.nodesource.com

    log_info "Installing Node ..."
    download $url/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor --yes -o $keyring
    echo "deb [signed-by=$keyring] $url/node_$NODE_MAJOR.x nodistro main" | sudo tee $source
    sudo apt-get update && sudo apt-get install -y nodejs
}

install_pnpm() {
    log_info "Installing pnpm ..."
    download https://get.pnpm.io/install.sh | sh -
}

#########################################################
# PostgreSQL
#########################################################

install_postgres() {
    if ! has apt; then
        log_error "Apt is required to install PostgreSQL."
        return 1
    fi

    if has psql; then
        log_info "PostgreSQL is already installed."
        return 0
    fi

    log_info "Installing PostgreSQL ..."
    sudo apt-get install -y postgresql-common
    sudo sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
    sudo apt-get update -y && sudo apt-get install -y postgresql
}

#########################################################
# Others
#########################################################

install_shellcheck() {
    install_from_github "koalaman/shellcheck" "$(shellcheck --version)" "shellcheck-v{{version}}.linux.x86_64.tar.xz" "-xJ --strip-components=1"
}

install_trivy() {
    install_from_github "aquasecurity/trivy" "$(trivy version || echo v0.0.0)" "trivy_{{version}}_Linux-64bit.tar.gz"
}

install_jfrog() {
    check_install_dir

    if has jf; then
        log_info "JFrog CLI is already installed."
        return 0
    fi

    log_info "Installing JFrog CLI ..."
    download "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/\[RELEASE\]/jfrog-cli-linux-amd64/jf" > "$INSTALL_DIR/bin/jf" && \
        chmod +x "$INSTALL_DIR/bin/jf" && \
        jf intro
}