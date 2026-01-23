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
