export NVM_LAZY_LOAD=true
source "$HOME/dotfiles/zsh-nvm.zsh"

export PATH=$PATH:$(go env GOPATH)/bin
alias ls="ls -G --color=auto"

alias gd="git diff"
alias gs="git status"
alias gdlc="git diff --shortstat HEAD^ HEAD"

# Directory containing your command files
DOTFILES_COMMANDS="${HOME}/dotfiles/commands"

if [[ -d $DOTFILES_COMMANDS ]]; then
  # Use nullglob-like behavior: if no match, the for loop won't run
  setopt localoptions null_glob
  for f in "${DOTFILES_COMMANDS}"/*.sh; do
    if [[ -f $f && -r $f ]]; then
      # shellcheck source=/dev/null
      source "$f"
    fi
  done
fi

# eval "$(starship init zsh)"
autoload -Uz colors && colors
setopt prompt_subst

build_exit_prefix() {
  local code=$?
  if (( code == 130 || code == 2 )); then
    EXIT_PREFIX="%F{white}[%F{yellow}${code}%F{white}]%f "
  elif (( code != 0 )); then
    EXIT_PREFIX="%F{white}[%F{red}${code}%F{white}]%f "
  else
    EXIT_PREFIX=""
  fi
}

typeset -A HOST_ALIAS
HOST_ALIAS=(
  Thomas-PowerBook-G3.local mbp 
)
get_host() {
  local h=${HOST:-$(hostname)}
  print -n -- ${HOST_ALIAS[$h]:-$h}
}

precmd_functions=()
precmd_functions+=(build_exit_prefix)

PS1='${EXIT_PREFIX}%F{white}(%F{magenta}%n%F{white}@%f%F{magenta}$(get_host)%F{white})%f %F{yellow}%~%f %F{cyan}$%f '
# Idk how much I like this yet, so I'm commenting it out for now
# RPROMPT='%F{white}[%F{magenta}%n%F{white}@%f%F{blue}%m%F{white}]%f'
