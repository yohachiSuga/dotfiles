#!/bin/bash

# install vscode
./code/vscode_install.sh

# install rust cli tools
# https://zaiste.net/posts/shell-commands-rust
./rust_clitools/install.sh

ln -s ./dotfiles/.zshrc ~/.zshrc
ln -s ./dotfiles/.gitconfig ~/.gitconfig

chsh -s /bin/zsh