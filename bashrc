export TERM=xterm-256color

# Thanks, Tim
if [[ "$OSTYPE" == "darwin"* ]]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

C_RESET='\[\e[0m\]'
C_BOLD='\[\e[1m\]'
C_WHITE='\[\e[37m\]'
C_RED='\[\e[31m\]'
C_GREEN='\[\e[32m\]'
C_YELLOW='\[\e[33m\]'
C_BLUE='\[\e[34m\]'
C_MAGENTA='\[\e[35m\]'
C_CYAN='\[\e[36m\]'

alias ls="ls -G --color=auto"
alias ssh="TERM=xterm-256color ssh -o ServerAliveInterval=60"
alias t="todo.sh"
alias i="grep -i"
alias gs="git status"
alias gcm="git commit -m"
alias gd="git diff"
alias gdlc="git diff --shortstat HEAD"
alias iamverysure="/usr/bin/sudo"
alias sudo="echo Are you sure? If so, run: iamverysure"

shopt -s cdspell 
shopt -s cmdhist histappend
shopt -s checkwinsize no_empty_cmd_completion

if [[ $BASH_VERSINFO -ge 4 ]]; then
  shopt -s checkjobs dirspell direxpand
fi

# Dot expansion
# i.e. cd ... goes ../../, etc.
function cd() {
    case "$1" in
        ...)    builtin cd ../..     ;;
        ....)   builtin cd ../../..  ;;
        .....)  builtin cd ../../../.. ;;
        *)      builtin cd "$@"      ;;
    esac
}

for file in $HOME/dotfiles/shell/commands/*.sh; do
	source "$file"
done

################
# PROMPT STUFF #
################
_get_host_alias() {
  case "$1" in
    Thomas-PowerBook-G3.local) printf '%s' "mbp" ;;
    ThomasPerBookG3)            printf '%s' "mbp" ;;
    *)                          printf '%s' "$1"  ;;
  esac
}

__get_host() {
  local h="${HOSTNAME:-$(hostname)}"

  # Try alias on full hostname first
  local alias
  alias=$(_get_host_alias "$h")
  if [[ "$alias" != "$h" ]]; then
    printf '%s' "$alias"
    return
  fi
  
  # Keep only the first two dot-separated parts
  local IFS='.'
  local parts=($h)
  if (( ${#parts[@]} >= 2 )); then
    printf '%s' "${parts[0]}.${parts[1]}"
  else
    printf '%s' "$h"
  fi
}

__get_git_info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  local git_status=""
  local color=$C_GREEN

  # dirty
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    git_status="*"
    color=$C_YELLOW
  fi

  # untracked
  if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    git_status="${git_status}!"
    color=$C_RED
  fi

  if [[ -n "$branch" ]]; then
    printf '%s' "${C_WHITE}:${color}${branch}${git_status}${C_RESET}"
  fi
}

__set_prompt() {
  local code=$?

  local p_exit=""
  if (( code == 130 || code == 2 )); then
    p_exit="${C_WHITE}[${C_YELLOW}${code}${C_WHITE}]${C_RESET} "
  elif (( code != 0 )); then
    p_exit="${C_WHITE}[${C_RED}${code}${C_WHITE}]${C_RESET} "
  fi

  local p_host="${C_MAGENTA}$(__get_host)${C_RESET}"
  local p_dir="${C_BLUE}\w${C_RESET}"
  local p_git=$(__get_git_info)${C_RESET}
  local p_symbol="${C_CYAN}\$${C_RESET}"

  PS1="${p_exit}${p_host}${C_WHITE}:${p_dir}${p_git} ${p_symbol} "
}

PROMPT_COMMAND="__set_prompt"

