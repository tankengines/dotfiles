export NVM_LAZY_LOAD=true
source "/Users/thomas/dotfiles/zsh-nvm.zsh"

export PATH=$PATH:$(go env GOPATH)/bin

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
eval "$(starship init zsh)"

