source "$HOME/dotfiles/shell/lang/zsh-nvm.zsh"
source "$HOME/dotfiles/shell/lang/go.zsh"

alias ls="ls -G --color=auto"
alias -g ...="../../"
alias -g ....="../../../"

alias ssh="TERM=xterm-256color ssh -o ServerAliveInterval=60"

alias gd="git diff"
alias gs="git status"
alias gdlc="git diff --shortstat HEAD^ HEAD"
alias gcm="git commit -m"

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias date="gdate"
fi

COMMANDS="${HOME}/dotfiles/shell/commands"
if [[ -d $COMMANDS ]]; then
  setopt localoptions null_glob
  for f in "${COMMANDS}"/*.sh; do
    if [[ -f $f && -r $f ]]; then
      source "$f"
    fi
  done
fi

PROMPT_MODULES="${HOME}/dotfiles/shell/prompt"
if [[ -d $PROMPT_MODULES ]]; then
  setopt localoptions null_glob
  for f in "${PROMPT_MODULES}"/*.zsh; do
    if [[ -f $f && -r $f ]]; then
      source "$f"
    fi
  done
fi

precmd_functions=()
precmd_functions+=(build_exit_prefix)
precmd_functions+=(time_command)

autoload -Uz colors && colors
setopt prompt_subst

PS1='${EXIT_PREFIX}%F{white}(%F{magenta}%n%F{white}@%f%F{magenta}$(get_host)%F{white})%f %F{yellow}%~%f %F{cyan}$%f '
