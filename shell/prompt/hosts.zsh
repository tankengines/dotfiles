typeset -A HOST_ALIAS
HOST_ALIAS=(
  Thomas-PowerBook-G3.local mbp 
)

get_host() {
  local h=${HOST:-$(hostname)}
  print -n -- ${HOST_ALIAS[$h]:-$h}
}
