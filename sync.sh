#!/bin/bash

ln -sfn ~/dotfiles/helix ~/.config/helix
ln -sfn ~/dotfiles/vim ~/.vim
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/zellij ~/.config/zellij
ln -sfn ~/dotfiles/alacritty ~/.config/alacritty

ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml 
ln -sf ~/dotfiles/zshrc ~/.zshrc

# Mac-specific
ln -s ~/SynologyDrive/Obsidian ~/notes

