#!/bin/sh

file_line() {
    line="$1"
    file="$2"
    grep -Fxq "$line" "$file" || echo "$line" >>"$file"
}

log_success() {
    fg_green=$(tput setaf 2)
    reset=$(tput sgr0)
    echo "${fg_green}$1${reset}"
}

log_info() {
    fg_blue=$(tput setaf 4)
    reset=$(tput sgr0)
    echo "${fg_blue}$1${reset}"
}

log_warn() {
    fg_yellow=$(tput setaf 3)
    reset=$(tput sgr0)
    echo "${fg_yellow}$1${reset}"
}

log_error() {
    fg_red=$(tput setaf 1)
    reset=$(tput sgr0)
    echo "${fg_red}$1${reset}"
}

setup_docker() {
    log_info "Installing docker ..."
    curl -fsSL https://get.docker.com | bash

    # rootless configuration
    log_info "Setting up docker rootless ..."
    dockerd-rootless-setuptool.sh install
}

setup_git() {
    log_info "Setting up various git configuration globally ..."
    git config --global core.editor 'code --wait'
    git config --global init.defaultbranch main
    git config --global push.autoSetupRemote true
    git config --global commit.gpgsign true
    git config --global gpg.format ssh
    git config --global gpg.ssh.defaultKeyCommand 'ssh-add -L'
    git config --global tag.gpgsign true

    ##################################################################
    ########### Some git aliases retrieved around the web ############
    ##################################################################

    git config --global --remove-section alias || true

    git config --global alias.alias '!git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /'
    git config --global alias.amend 'commit --amend --no-edit'
    git config --global alias.branches "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
    git config --global alias.c 'commit'
    git config --global alias.cp 'cherry-pick'
    git config --global alias.current 'rev-parse --abbrev-ref HEAD'
    git config --global alias.last 'log -1 HEAD --stat'
    git config --global alias.ll 'log --oneline'
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    # shellcheck disable=SC2016
    git config --global alias.mad '!f() { git reset --hard ${1-origin}/${2-$(git current)}; }; f'
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
}

setup_go() {
    log_info "Installing golang ..."
    go=$(curl -fsSL "https://go.dev/dl/?mode=json" | jq -r '.[0].version')
    rm -rf "$HOME/.local/go" && mkdir -p "$HOME/.local/go"
    curl -fsSL "https://go.dev/dl/$go.linux-amd64.tar.gz" | (cd "$HOME/.local/go" && tar -xz --strip-components=1)
    for item in "go" "gofmt"; do
        chmod +x "$HOME/.local/go/bin/$item" && ln -sf "$HOME/.local/go/bin/$item" "$HOME/.local/bin/$item"
    done

    log_info "Installing golangci-lint ..."
    curl -fsSL "https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh" | sh -s -- -b "$HOME/go/bin"

    log_info "Installing hugo ..."
    rm -rf "$HOME/.local/hugo" && mkdir -p "$HOME/.local/hugo"
    hugo=$(curl -fsSL "https://api.github.com/repos/gohugoio/hugo/releases/latest" | jq -r '.tag_name')
    curl -fsSL "https://github.com/gohugoio/hugo/releases/download/$hugo/hugo_extended_${hugo#v*}_linux-amd64.tar.gz" | (cd "$HOME/.local/hugo" && tar -xz)
    chmod +x "$HOME/.local/hugo/hugo" && ln -sf "$HOME/.local/hugo/hugo" "$HOME/.local/bin/hugo"

    log_info "Installing goreleaser ..."
    rm -rf "$HOME/.local/goreleaser" && mkdir -p "$HOME/.local/goreleaser"
    goreleaser=$(curl -fsSL "https://api.github.com/repos/goreleaser/goreleaser/releases/latest" | jq -r '.tag_name')
    curl -fsSL "https://github.com/goreleaser/goreleaser/releases/download/$goreleaser/goreleaser_Linux_x86_64.tar.gz" | (cd "$HOME/.local/goreleaser" && tar -xz)
    chmod +x "$HOME/.local/goreleaser/goreleaser" && ln -sf "$HOME/.local/goreleaser/goreleaser" "$HOME/.local/bin/goreleaser"

    log_info "Installing govulncheck ..."
    go install golang.org/x/vuln/cmd/govulncheck@latest
}

setup_k8s() {
    log_info "Installing kubectl ..."
    kubectl=$(curl -fsSL "https://dl.k8s.io/release/stable.txt")
    curl -fsSL "https://dl.k8s.io/release/$kubectl/bin/linux/amd64/kubectl" -o "$HOME/.local/bin/kubectl"
    chmod +x "$HOME/.local/bin/kubectl"

    log_info "Installing helm 3 ..."
    curl -fsSL "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | HELM_INSTALL_DIR="$HOME/.local/bin" USE_SUDO="false" bash

    log_info "Installing k9s ..."
    rm -rf "$HOME/.local/k9s" && mkdir -p "$HOME/.local/k9s"
    curl -fsSL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz" | (cd "$HOME/.local/k9s" && tar -xz)
    chmod +x "$HOME/.local/k9s/k9s" && ln -sf "$HOME/.local/k9s/k9s" "$HOME/.local/bin/k9s"
}

setup_nodejs() {
    keyring=/etc/apt/keyrings/nodesource.gpg
    source=/etc/apt/sources.list.d/nodesource.list
    url=https://deb.nodesource.com

    log_info "Installing nodejs ..."
    curl -fsSL $url/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor --yes -o $keyring
    NODE_MAJOR=20
    echo "deb [signed-by=$keyring] $url/node_$NODE_MAJOR.x nodistro main" | sudo tee $source
    sudo apt-get update && sudo apt-get install -y nodejs

    log_info "Installing pnpm ..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
}

setup_bun() {
    log_info "Installing bun ..."
    curl -fsSL https://bun.sh/install | bash
}

setup_postgres() {
    log_info "Installing postgresql ..."
    sudo apt-get install -y postgresql-common
    sudo sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
    sudo apt-get update -y && sudo apt-get install -y postgresql
}

setup_shellcheck() {
    log_info "Installing shellcheck ..."
    rm -rf "$HOME/.local/shellcheck" && mkdir -p "$HOME/.local/shellcheck"
    shellcheck=$(curl -fsSL "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | jq -r '.tag_name')
    curl -fsSL "https://github.com/koalaman/shellcheck/releases/download/$shellcheck/shellcheck-$shellcheck.linux.x86_64.tar.xz" | (cd "$HOME/.local/shellcheck" && tar -xJ --strip-components=1)
    chmod +x "$HOME/.local/shellcheck/shellcheck" && ln -sf "$HOME/.local/shellcheck/shellcheck" "$HOME/.local/bin/shellcheck"
}

setup_trivy() {
    log_info "Installing trivy ..."
    rm -rf "$HOME/.local/trivy" && mkdir -p "$HOME/.local/trivy"
    trivy=$(curl -fsSL "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | jq -r '.tag_name')
    curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/$trivy/trivy_${trivy#v*}_Linux-64bit.tar.gz" | (cd "$HOME/.local/trivy" && tar -xz)
    chmod +x "$HOME/.local/trivy/trivy" && ln -sf "$HOME/.local/trivy/trivy" "$HOME/.local/bin/trivy"
}

usage() {
    echo "$(basename "$0") -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
        --go            Installs or upgrades go, golangci-lint, hugo and goreleaser
        --psql          Installs or upgrades postgresql
    -b, --bun           Installs or upgrades bun
    -d, --docker        Installs or upgrades docker (rootless)
    -g, --git           Setup default git configuration
    -h, --help          Shows this help message
    -k, --k8s           Installs or upgrades kubectl with k alias, k9s and helm
    -n, --nodejs        Installs or upgrades nodejs and pnpm
    -s, --shellcheck    Installs or upgrades shellcheck
    -t, --trivy         Installs or upgrades trivy
    -v, --verbose       Enable verbose mode to log every step

Notes:
    All installation are done in $HOME/.local."
}

PARAMS=""
while [ "$#" -ne 0 ]; do
    case "$1" in
    --go) GO=0 && shift ;;
    --psql) PSQL=0 && shift ;;
    -b | --bun) BUN=0 && shift ;;
    -d | --docker) DOCKER=0 && shift ;;
    -g | --git) GIT=0 && shift ;;
    -h | --help) usage && exit 0 ;;
    -k | --k8s) K8S=0 && shift ;;
    -n | --node*) NODEJS=0 && shift ;;
    -s | --shellcheck) SHELLCHECK=0 && shift ;;
    -t | --trivy) TRIVY=0 && shift ;;
    -v | --verbose) set -x && shift ;;
    -*) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    # --*=) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    *) PARAMS="$PARAMS $1" && shift ;; # preserve positional arguments
    esac
done

set -e

# set positional arguments in their proper place
eval set -- "$PARAMS"

if [ "$(uname -o)" = "GNU/Linux" ]; then
    log_info "Installing workspace ..."
    mkdir -p "$HOME/.local/bin"

    log_info "Upgrading current dependencies and distribution ..."
    sudo apt update -y && sudo apt dist-upgrade

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt install -y autojump bash-completion ca-certificates curl file git gnupg jq keychain make man rsync tree uidmap unzip vim wget zsh
    # sudo apt install openjdk-17-jdk maven redis-server
fi

[ "$BUN" = 0 ] && setup_bun
[ "$DOCKER" = 0 ] && setup_docker
[ "$GIT" = 0 ] && setup_git
[ "$GO" = 0 ] && setup_go
[ "$K8S" = 0 ] && setup_k8s
[ "$NODEJS" = 0 ] && setup_nodejs
[ "$PSQL" = 0 ] && setup_postgres
[ "$SHELLCHECK" = 0 ] && setup_shellcheck
[ "$TRIVY" = 0 ] && setup_trivy

if [ "$(uname -o)" = "GNU/Linux" ]; then
    log_info "Auto uninstalling unnecessary dependencies ..."
    sudo apt autoremove -y
fi
