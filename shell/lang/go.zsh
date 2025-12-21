if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH=$PATH:/usr/local/go/bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=$PATH:$(go env GOPATH)/bin
fi
