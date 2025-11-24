ta() {
  local session_name=${1:-${PWD:t}}
  tmux attach -t "$session_name" || tmux new -s "$session_name"
}

