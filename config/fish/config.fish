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

nvm use lts --silent
rvm default
