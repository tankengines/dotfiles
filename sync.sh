#!/bin/bash

ln -sfn ~/dotfiles/helix ~/.config/helix
ln -sfn ~/dotfiles/vim ~/.vim
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/zellij ~/.config/zellij
ln -sfn ~/dotfiles/zellij/layouts ~/.config/layouts
ln -sfn ~/dotfiles/alacritty ~/.config/alacritty

ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml 
ln -sf ~/dotfiles/zshrc.zsh ~/.zshrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

# Mac-specific
ln -sfn ~/SynologyDrive/Obsidian ~/notes

