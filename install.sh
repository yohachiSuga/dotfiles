#!/bin/bash

# install vscode
./code/vscode_install.sh

ln -s ./dotfiles/.zshrc ~/.zshrc
ln -s ./dotfiles/.gitconfig ~/.gitconfig

chsh -s /bin/zsh