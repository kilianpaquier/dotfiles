export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=()

dir="$(dirname $(readlink -f "$HOME/.zshrc"))"
ZSH_CUSTOM="$dir/custom"
source $dir/.user.zshrc
unset dir

source $ZSH/oh-my-zsh.sh