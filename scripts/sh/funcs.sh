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
