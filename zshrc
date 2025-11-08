export NVM_LAZY_LOAD=true
source "/Users/thomas/dotfiles/zsh-nvm.zsh"

export PATH=$PATH:$(go env GOPATH)/bin
alias ls="ls --color=auto"

alias gd="git diff"
alias gs="git status"
alias gdlc="git diff --shortstat HEAD^ HEAD"

eval "$(starship init zsh)"

