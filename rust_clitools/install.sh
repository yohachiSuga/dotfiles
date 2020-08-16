#!/bin/bash

OS=`lsb_release -si`
VER=`lsb_release -sr`
echo "your os could be $OS $VER"

if [ $OS = "LinuxMint" ]; then
  # setup RUST tools
  # setup cargo for installation
  sudo apt install -y curl
  curl https://sh.rustup.rs -sSf | sh
  source $HOME/.cargo/env

  # install ripgrep and remove debug symbol for optimization.
  # For Ubuntu you can use apt-get
  ~/.cargo/bin/cargo install ripgrep
  rg strip

  # install bat
  # For Ubuntu you can use apt-get
  ~/.cargo/bin/cargo install bat

  ~/.cargo/bin/cargo install fd-find

  ~/.cargo/bin/cargo install exa
  echo 'Please execute $HOME/.cargo/env'
elif [ $OS = "Ubuntu" ]; then
  echo "install by apt, but not tested yet."
  sudo apt-get -y install bat ripgrep fd-find exa
else
  echo "not support $OS currently"
fi