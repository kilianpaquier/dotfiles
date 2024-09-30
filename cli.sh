#!/bin/sh

file_line() {
    line="$1"
    file="$2"
    grep -Fxq "${line}" "${file}" || echo "${line}" >>"${file}"
}

log_success() {
    fg="\033[0;32m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_info() {
    fg="\033[0;34m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_warn() {
    fg="\033[0;33m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_error() {
    fg="\033[0;31m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

setup_docker() {
    log_info "Installing docker ..."
    curl -fsSL https://get.docker.com | bash

    # rootless configuration
    log_info "Setting up docker rootless ..."
    dockerd-rootless-setuptool.sh install
}

install_github() {
    owner="$1"
    repo="$2"
    asset="$3"

    log_info "Checking ${repo} releases ..."
    current_version=$("${repo}" version || echo "v0.0.0")
    new_version=$(curl -fsSL "https://api.github.com/repos/${owner}/${repo}/releases/latest" | jq -r '.tag_name')
    if echo "${current_version}" | grep -Eq "${new_version}"; then
        log_info "Latest ${repo} version ${new_version} already installed"
        return 0
    fi

    # OS="linux" # change it depending on our case
    # ARCH="amd64" # change it depending on our case

    asset="$(echo "${asset}" | sed "s/{{with_version}}/${new_version#v*}/g")"
    url="https://github.com/${owner}/${repo}/releases/download/${new_version}/${asset}"
    log_info "Installing ${repo} version ${new_version} at ${url}"

    curl -fsSL "$url" -o "/tmp/${asset}"
    mkdir -p "/tmp/${repo}/${new_version}"

    if [ "${asset##*.}" = "xz" ]; then
        tar -xf "/tmp/${asset}" -C "/tmp/${repo}/${new_version}" --strip-components=1
    else # we assume the else case is gz
        tar -xzf "/tmp/${asset}" -C "/tmp/${repo}/${new_version}" --strip-components=1
    fi
    cp "/tmp/${repo}/${new_version}/${repo}" "${HOME}/.local/bin/${repo}"
}

setup_git() {
    log_info "Setting up various git configuration globally ..."
    git config --global core.editor 'code --wait'
    git config --global init.defaultbranch main
    git config --global push.autoSetupRemote true

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
    git config --global alias.last 'log -1 HEAD --stat'
    git config --global alias.ll 'log --oneline'
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
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
}

setup_go() {
    log_info "Checking go releases ..."
    current_go_version=$(go version || echo "go0.0.0")
    new_go_version=$(curl -fsSL "https://go.dev/dl/?mode=json" | jq -r '.[0].version')
    if echo "${current_go_version}" | grep -Eq "${new_go_version}"; then
        log_info "Latest go version ${new_go_version} already installed"
    else
        rm -rf "${HOME}/.local/go" && mkdir -p "${HOME}/.local/go"
        curl -fsSL "https://go.dev/dl/${new_go_version}.linux-amd64.tar.gz" | (cd "${HOME}/.local/go" && tar -xz --strip-components=1)
        for item in "go" "gofmt"; do
            chmod +x "${HOME}/.local/go/bin/${item}" && ln -sf "${HOME}/.local/go/bin/${item}" "${HOME}/.local/bin/${item}"
        done
    fi

    log_info "Checking golangci-lint releases ..."
    curl -fsSL "https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh" | sh -s -- -b "${HOME}/.local/bin"

    install_github "gohugoio" "hugo" "hugo_extended_{{with_version}}_linux-amd64.tar.gz"
    install_github "goreleaser" "goreleaser" "goreleaser_Linux_x86_64.tar.gz"

    log_info "Installing govulncheck ..."
    go install golang.org/x/vuln/cmd/govulncheck@latest
}

setup_k8s() {
    log_info "Installing kubectl ..."
    current_kubectl_version=$(shellcheck --version || echo "0.0.0")
    new_kubectl_version=$(curl -fsSL "https://dl.k8s.io/release/stable.txt")
    if echo "${current_kubectl_version}" | grep -Eq "${new_kubectl_version#v*}"; then
        log_info "Latest kubectl version already installed"
    else
        curl -fsSL "https://dl.k8s.io/release/${new_kubectl_version}/bin/linux/amd64/kubectl" -o "${HOME}/.local/bin/kubectl"
        chmod +x "${HOME}/.local/bin/kubectl"
    fi

    log_info "Installing helm 3 ..."
    curl -fsSL "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | HELM_INSTALL_DIR="${HOME}/.local/bin" USE_SUDO="false" bash

    install_github "derailed" "k9s" "k9s_Linux_amd64.tar.gz"
}

setup_nodejs() {
    keyring=/etc/apt/keyrings/nodesource.gpg
    source=/etc/apt/sources.list.d/nodesource.list
    url=https://deb.nodesource.com

    log_info "Installing nodejs ..."
    curl -fsSL ${url}/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor --yes -o ${keyring}
    NODE_MAJOR=20
    echo "deb [signed-by=${keyring}] ${url}/node_${NODE_MAJOR}.x nodistro main" | sudo tee ${source}
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
    install_github "koalaman" "shellcheck" "shellcheck-v{{with_version}}.linux.x86_64.tar.xz"
}

setup_trivy() {
    install_github "aquasecurity" "trivy" "trivy_{{with_version}}_Linux-64bit.tar.gz"
}

usage() {
    echo "$(basename "$0") -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
        --go            Install or upgrade go, golangci-lint, hugo and goreleaser
        --psql          Install or upgrade postgresql
    -b, --bun           Install or upgrade bun
    -d, --docker        Install or upgrade docker (rootless)
    -g, --git           Setup default git configuration
    -h, --help          Show this help message
    -k, --k8s           Install or upgrade kubectl with k alias, k9s and helm
    -n, --nodejs        Install or upgrade nodejs and pnpm
    -s, --shellcheck    Install or upgrade shellcheck
    -t, --trivy         Install or upgrade trivy
    -v, --verbose       Enable verbose mode to log every step

Notes:
    All installation are done in ${HOME}/.local."
}

PARAMS=""
while [ "$#" -ne 0 ]; do
    case "$1" in
    --go) GO=0 && shift ;;
    --psql) PSQL=0 && shift ;;
    -b | --bun) BUN=0 && shift ;;
    -d | --docker) DOCKER=0 && shift ;;
    -g | --git) GIT=0 && shift ;;
    -h | --help) usage && exit 0 ;; # early return in case help is asked
    -k | --k8s) K8S=0 && shift ;;
    -n | --node*) NODEJS=0 && shift ;;
    -s | --shellcheck) SHELLCHECK=0 && shift ;;
    -t | --trivy) TRIVY=0 && shift ;;
    -v | --verbose) set -x && shift ;;
    -*) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    # --*=) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    *) PARAMS="${PARAMS} $1" && shift ;; # preserve positional arguments
    esac
done

set -e

# set positional arguments in their proper place
eval set -- "${PARAMS}"

if [ "$(uname -o)" = "GNU/Linux" ]; then
    log_info "Installing workspace ..."
    mkdir -p "${HOME}/.local/bin"

    log_info "Upgrading current dependencies and distribution ..."
    sudo apt update -y && sudo apt dist-upgrade

    log_info "Installing useful dependencies (git, curl, jq, vim, etc.) ..."
    sudo apt install -y autojump bash-completion ca-certificates curl file git gnupg jq keychain make man rsync tree uidmap unzip vim wget zsh
    # sudo apt install openjdk-17-jdk maven redis-server
fi

[ "${BUN}" = 0 ] && setup_bun
[ "${DOCKER}" = 0 ] && setup_docker
[ "${GIT}" = 0 ] && setup_git
[ "${GO}" = 0 ] && setup_go
[ "${K8S}" = 0 ] && setup_k8s
[ "${NODEJS}" = 0 ] && setup_nodejs
[ "${PSQL}" = 0 ] && setup_postgres
[ "${SHELLCHECK}" = 0 ] && setup_shellcheck
[ "${TRIVY}" = 0 ] && setup_trivy

if [ "$(uname -o)" = "GNU/Linux" ]; then
    log_info "Auto uninstalling unnecessary dependencies ..."
    sudo apt autoremove -y
fi
