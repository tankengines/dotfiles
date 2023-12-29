if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval "$(/opt/homebrew/bin/brew shellenv)"

abbr --add  .. cd ..
abbr --add ... cd ../..
abbr --add .... cd ../../..
abbr --add ..... cd ../../../..

set fish_greeting
starship init fish | source

set --universal nvm_default_version v18.5.0
#nvm use lts --silent
rvm default
