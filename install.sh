#!/bin/bash

DOTFILES_PATH=~/dotfiles

install_chrome() {
  echo "install chrome"
  if type "google-chrome" > /dev/null 2>&1; then
    echo "already google-chrome installed."
  else
    sudo apt install -y wget
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo apt update -y && sudo apt -y install google-chrome-stable
  fi
}

install_byobu() {
  echo "install byobu"
  if !(type "byobu" > /dev/null 2>&1); then
    sudo apt update -y && sudo apt install -y byobu xsel
  else
    echo "byobu already installed."
  fi
  ln -snfv $DOTFILES_PATH/.tmux.conf $DOTFILES_PATH/.tmux.conf
}

install_rust() {
    sudo apt-get -y install build-essential
    sh -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_util() {
    # git client
    sudo apt install -y tig peco vim wget

    # install fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_all() {
  install_byobu
  install_chrome
  install_util
}

install_zsh_conf() {
  sudo apt-get install -y curl
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

configure_all() {
  install_zsh_conf
  ln -snfv $DOTFILES_PATH/.zshrc ~/.zshrc
  ln -snfv $DOTFILES_PATH/.gitconfig ~/.gitconfig
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
  # ./rust_clitools/install.sh

  configure_all
fi
