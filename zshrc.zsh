if [[ -e "$HOME/dotfiles/shell/lag/zsh-nvm.zsh" ]]; then
  source "$HOME/dotfiles/shell/lang/zsh-nvm.zsh"
fi

if [[ -e "$HOME/dotfiles/shell/lang/go.zsh" ]]; then
  source "$HOME/dotfiles/shell/lang/go.zsh"
fi

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
# defensive checking; only add to precmd if these are found
if typeset -f build_exit_prefix >/dev/null; then
  precmd_functions+=(build_exit_prefix)
fi

if typeset -f time_command >/dev/null; then
  precmd_functions+=(time_command)
fi

autoload -Uz colors && colors
setopt prompt_subst

PS1='${EXIT_PREFIX}%F{white}(%F{magenta}$(get_host)%f%F{white}:%f%F{magenta}%~%f$(get_git_info)%F{white}) %F{cyan}$%f '
