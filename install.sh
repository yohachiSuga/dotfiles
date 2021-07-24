#!/bin/bash

install_chrome() {
  sudo apt install -y wget
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo apt update -y && sudo apt -y install google-chrome-stable
}

install_byobu() {
  sudo apt update -y && sudo apt install -y byobu
}

install_all() {
  install_byobu
  install_chrome
}

configure_all() {
  ln -s ./dotfiles/.zshrc ~/.zshrc
  ln -s ./dotfiles/.gitconfig ~/.gitconfig
  chsh -s /bin/zsh
}

if [ `uname` != "Linux" ]; then
  echo "this is not target platform." 
else
  # install utilities
  install_all

  # install vscode
  ./code/vscode_install.sh

  # install rust cli tools
  # https://zaiste.net/posts/shell-commands-rust
  ./rust_clitools/install.sh

  configure_all
fi