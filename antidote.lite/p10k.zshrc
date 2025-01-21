# .zshrc

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache/zsh"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
ZPLUGINDIR="$ZDOTDIR/plugins"

ANTIDOTE_LITE_HOME="$XDG_CACHE_HOME"
ANTIDOTE_LITE_GITURL="git@github.com:"

# load antidote lite, meaning just:
#   - plugin-clone
#   - plugin-compile
#   - plugin-load
#   - plugin-script
#   - plugin-update
# see for yourself how simple this plugin manager is
if [ ! -f "$ZDOTDIR/lib/antidote.lite.zsh" ]; then
  mkdir -p $ZDOTDIR/lib
  curl -fsSL https://raw.githubusercontent.com/mattmc3/zsh_unplugged/main/antidote.lite.zsh -o $ZDOTDIR/lib/antidote.lite.zsh
fi
source "$ZDOTDIR/lib/antidote.lite.zsh"

prompts=(
  romkatv/powerlevel10k
  sindresorhus/pure
)
plugin-clone $prompts
plugin-load --kind fpath $prompts

before_prompt=(
  belak/zsh-utils/prompt
  ohmyzsh/ohmyzsh/plugins/ssh-agent

  belak/zsh-utils/completion
  mroth/evalcache

  # installation plugins
  kilianpaquier/zsh-plugins/mise
  kilianpaquier/zsh-plugins/docker-rootless
  kilianpaquier/zsh-plugins/fzf
)
plugin-clone $before_prompt
plugin-load $before_prompt

prompt powerlevel10k
[ -f "$ZDOTDIR/.zshrc" ] && . "$ZDOTDIR/.zshrc" # source p10k

after_prompt=(
  romkatv/zsh-defer

  # deferred
  kilianpaquier/zsh-plugins/bash-aliases
  kilianpaquier/zsh-plugins/git-alias
  kilianpaquier/zsh-plugins/goenv
  kilianpaquier/zsh-plugins/highlight-styles
  kilianpaquier/zsh-plugins/misenv

  # zsh user experience
  Aloxaf/fzf-tab
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-syntax-highlighting
)
plugin-clone $after_prompt
plugin-load $after_prompt