set -g -x PATH /usr/local/bin $PATH
set -x EDITOR code
eval (python -m virtualfish)

alias git-summary="~/.dotfiles/git-summary/git-summary"