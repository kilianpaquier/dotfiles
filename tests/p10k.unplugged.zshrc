#!/bin/zsh
# shellcheck disable=SC1071

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache/zsh"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"

ZSH="$ZDOTDIR"
ZSH_CUSTOM="$ZSH/custom"

ANTIDOTE_LITE_CURLURL="https://raw.githubusercontent.com/"
ANTIDOTE_LITE_GITURL="git@github.com:"

# see https://raw.githubusercontent.com/mattmc3/zsh_unplugged/main/zsh_unplugged.zsh
function plugin-load {
  for repo in $@; do
    name="${repo/.*}" # remove everything after the first dot
    plugdir="$ZPLUGINDIR/${name:t}"
    initfile="$plugdir/${name:t}.plugin.zsh"

    case $repo in
      # new behavior, plugin is curl'ed
      curl:*)
        repo="${repo#curl:}"
        if [ ! -f "$initfile" ]; then
          url="${ANTIDOTE_LITE_CURLURL:-"https://raw.githubusercontent.com/"}$repo"
          echo "Curl '$url' ..."
          mkdir -p "$plugdir" && curl -fsSL "$url" -o "$initfile"
          unset url
        fi
        ;;
      # default behavior introduced by zsh_unplugged, plugin is cloned
      git:*)
        repo="${repo#git:}"
        if [ ! -d "$plugdir" ]; then
          url="${ANTIDOTE_LITE_GITURL:-"https://github.com/"}$repo"
          echo "Clone '$url' ..."
          git clone -q --depth 1 --recursive --shallow-submodules "$url" "$plugdir"
          unset url
        fi
        ;;
      *) echo >&2 "Invalid plugin '$repo', must start with 'curl:' or 'git:'." && continue ;;
    esac

    if [ ! -f $initfile ]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi

    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
    unset plugdir initfile
  done
  unset repo
}

plugins=(
  git:romkatv/powerlevel10k

  curl:ohmyzsh/ohmyzsh/master/plugins/ssh-agent/ssh-agent.plugin.zsh

  curl:belak/zsh-utils/master/completion/completion.plugin.zsh
  git:mroth/evalcache

  # installation plugins
  curl:kilianpaquier/zsh-plugins/main/mise/mise.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/docker-rootless/docker-rootless.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/fzf/fzf.plugin.zsh
)
plugin-load $plugins
unset plugins

# source p10k
[ -f "$ZDOTDIR/.zshrc" ] && source "$ZDOTDIR/.zshrc"

plugins=(
  git:romkatv/zsh-defer

  # deferred
  curl:kilianpaquier/zsh-plugins/main/bash-aliases/bash-aliases.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/git-alias/git-alias.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/goenv/goenv.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/highlight-styles/highlight-styles.plugin.zsh
  curl:kilianpaquier/zsh-plugins/main/misenv/misenv.plugin.zsh

  # zsh user experience
  git:Aloxaf/fzf-tab
  git:zsh-users/zsh-autosuggestions
  git:zsh-users/zsh-completions
  git:zsh-users/zsh-history-substring-search
  git:zsh-users/zsh-syntax-highlighting
)
plugin-load $plugins
unset plugins
