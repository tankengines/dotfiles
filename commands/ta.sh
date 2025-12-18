ta() {
  local session_name=${1:-${PWD:t}}

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" \; switch-client -t "$session_name"
  else
    tmux attach -t "$session_name" || tmux new -s "$session_name"
  fi
}

