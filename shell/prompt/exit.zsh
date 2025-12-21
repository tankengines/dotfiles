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
