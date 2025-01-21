# .zshrc

read me < <(readlink -f "$HOME/.zshrc")
read dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/z4h/.zshrc"
