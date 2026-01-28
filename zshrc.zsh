if [[ -e "$HOME/dotfiles/shell/lang/zsh-nvm.zsh" ]]; then
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

LANGS="${HOME}/dotfiles/shell/lang"
if [[ -d $LANGS ]]; then
  setopt localoptions null_glob
  for f in "${LANGS}"/*.zsh; do
    if [[ -f $f && -r $f ]]; then
      source "$f"
    fi
  done
fi

################
# PROMPT STUFF #
################
typeset -A HOST_ALIAS
HOST_ALIAS=(
  Thomas-PowerBook-G3.local mbp 
  ThomasPerBookG3 mbp
)

get_host() {
  local h=${HOST:-$(hostname)}
  print -n -- ${HOST_ALIAS[$h]:-$h}
}

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

get_git_info() {
  # are we in a git repo?
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local git_status=""
  local color="green"

  # dirty
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    git_status="*"
    color="yellow"
  fi

  # untracked
  if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    color="red"
  fi

  if [[ -n $branch ]]; then
    print -n -- "%F{white}:%F{${color}}${branch}${git_status}%f"
  fi
}

# https://derrick.blog/2022/12/21/command-timing-in-zsh/
# but I used date instead of gdate
preexec() {
    timer=$(($(date +%s%N)/1000000))
}

converts() {
    local t=$1

    local d=$((t / 1000 / 60 / 60 / 24))
    local h=$((t / 1000 / 60 / 60 % 24))
    local m=$((t / 1000 / 60 % 60))
    local s=$((t / 1000 % 60))
    local ms=$((t % 1000))

    if [[ $s -lt 1 ]]; then
        return
    fi

    local result=""
    [[ $d -gt 0 ]] && result+=" ${d}d"
    [[ $h -gt 0 ]] && result+=" ${h}h"
    [[ $m -gt 0 ]] && result+=" ${m}m"
    [[ $s -gt 0 ]] && result+=" ${s}s"
    [[ $ms -gt 0 ]] && result+=" ${ms}ms"
    
    echo "$result"
}

time_command() {
    if [[ -n "$timer" ]]; then
        now=$(($(date +%s%N)/1000000))
        elapsed=$((now - timer))

        reset_color='%f'
        RPROMPT="%F{cyan} $(converts "$elapsed") $reset_color"
        export RPROMPT
        unset timer
    else
        # reset if no command
        RPROMPT=""
    fi
}

precmd_functions=()
precmd_functions+=(build_exit_prefix)
precmd_functions+=(time_command)

autoload -Uz colors && colors
setopt prompt_subst

PS1='${EXIT_PREFIX}%F{white}(%F{magenta}$(get_host)%f%F{white}:%f%F{magenta}%~%f$(get_git_info)%F{white}) %F{cyan}$%f '
