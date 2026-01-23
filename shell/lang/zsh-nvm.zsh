# Lazy-load nvm - only load when actually needed
export NVM_DIR="$HOME/.nvm"

_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

# Create stub functions that load nvm on first use
nvm() {
  unset -f nvm node npm npx
  _load_nvm
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  _load_nvm
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  _load_nvm
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  _load_nvm
  npx "$@"
}
