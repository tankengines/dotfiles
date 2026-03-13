za() {
  local session_name=${1:-${PWD##*/}}
  zellij attach "$session_name" || zellij -s "$session_name"
}

