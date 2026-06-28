export TERM=xterm-256color

export HISTSIZE=-1
export HISTFILESIZE=-1

# Thanks, Tim
if [[ "$OSTYPE" == "darwin"* ]]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# Golang
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH=$PATH:/usr/local/go/bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=$PATH:$(go env GOPATH)/bin
fi

# OCaml
test -r "${HOME}/.opam/opam-init/init.sh" && . "${HOME}/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true

# Janet
if command -v janet >/dev/null 2>&1; then
  export JANET_TREE="$HOME/.local/share/janet"
  export JANET_PATH="$HOME/.local/share/janet/lib" # otherwise it reads from Nix store path. also, remember to add "/run/current-system/sw/bin/janet" shebang to top of LSP in bin/ 
  export PATH=$PATH:$HOME/.local/share/janet/bin
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
if [ -x /run/wrappers/bin/sudo ]; then
  alias iamverysure="/run/wrappers/bin/sudo"
  alias sudo="echo Are you sure? If so, run: iamverysure"
elif [ -x /usr/bin/sudo ]; then
  alias iamverysure="/usr/bin/sudo"
  alias sudo="echo Are you sure? If so, run: iamverysure"
fi


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

if (command -v fzf > /dev/null 2>&1); then
  eval "$(fzf --bash)"
fi

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

# thanks https://gist.github.com/Ragnoroct/c4c3bf37913afb9469d8fc8cffea5b2f
__get_git_branch() {
  local headfile head branch
  local dir="$PWD"

  while [ -n "$dir" ]; do
    if [ -e "$dir/.git/HEAD" ]; then
      headfile="$dir/.git/HEAD"
      break
    fi
    dir="${dir%/*}"
  done


  if [ -e "$headfile" ]; then
    read -r head < "$headfile" || return
    case "$head" in
      ref:*) branch="${head##*/}" ;;
      "") branch="";;
      *) branch="${head:0:7}" ;; # Detached head

    esac
  fi

  if [ -z "$branch" ]; then
    return 0
  fi

  echo "$branch"
}

__get_git_info() {
  local branch
  branch=$(__get_git_branch)
  if [ -z "$branch" ]; then
    return 0
  fi
  
  local git_status
  local color=$C_GREEN
  local porcelain
  porcelain=$(git status --porcelain 2>/dev/null)

  if [[ -n "$porcelain" ]]; then
    if grep -q '^??' <<< "$porcelain"; then
      git_status="*!"
      color=$C_RED
    else
      git_status="*"
      color=$C_YELLOW
    fi
  fi

  printf '%s' "${C_WHITE}[${C_BOLD}${color}${branch}${git_status}${C_RESET}${C_WHITE}]"
}

__short_pwd() {
    local pwd_str="$PWD"
    if [[ "$pwd_str" == "$HOME" ]]; then
        echo "~"
        return
    elif [[ "$pwd_str" == "$HOME/"* ]]; then
        pwd_str="~${pwd_str#$HOME}"
    fi

    local IFS='/'
    read -ra parts <<< "$pwd_str"
    local result=""

    for (( i = 0; i < ${#parts[@]} - 1; i++ )); do
        local part="${parts[$i]}"
        if [[ -n "$part" ]]; then
            if [[ -z "$result" && "$part" == "~" ]]; then
                result="~"  # Don't prepend /
            else
                result+="/${part:0:1}"
            fi
        fi
    done

    result+="/${parts[-1]}"
    echo "${result:-/}"
}

__set_prompt() {
  local p_exit p_host p_dir p_git p_symbol p_venv
  local code=${1:-$?}

  if (( code == 130 || code == 2 )); then
    p_exit="${C_YELLOW}${code}${C_RESET} "
  elif (( code != 0 )); then
    p_exit="${C_RED}${code}${C_RESET} "
  fi

  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    p_venv="${C_WHITE}[${C_CYAN}$(basename "$VIRTUAL_ENV")${C_WHITE}]${C_RESET}"
  fi

  p_host="${C_WHITE}[${C_BOLD}${C_MAGENTA}$(__get_host)${C_RESET}${C_WHITE}]"
  p_dir="${C_WHITE}[${C_BOLD}${C_BLUE}$(__short_pwd)${C_RESET}${C_WHITE}]"
  p_git=$(__get_git_info)${C_RESET}

  # genius ; prompt by @fanf https://lobste.rs/c/k5goph
  # so you can copy paste commands in triple clicks; the ":" is a no-op, so
  # the exit code is not executed with your code (until a new statement,
  # semicolon terminates the no-op)
  p_symbol="${C_WHITE}: ${p_exit}${C_CYAN};${C_RESET}"

  PS1="${p_venv}${p_host}${p_dir}${p_git}\n${p_symbol} "
}

PROMPT_COMMAND='__set_prompt "$?"'

