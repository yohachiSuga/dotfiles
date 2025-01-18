#!/bin/sh
set -xe

install_vscode() {
    cd `dirname $0`
    sudo apt install -y curl
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    rm packages.microsoft.gpg

    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code
}

configure_vscode() {
    cd `dirname $0`
    VSCODE_CONFIG_DIR=~/.config/Code/User
    CODE_DOTFILES_DIR=`pwd`
    rm -f "$VSCODE_CONFIG_DIR/settings.json"
    ln -snvf "$CODE_DOTFILES_DIR/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    rm -f "$VSCODE_CONFIG_DIR/keybindings.json"
    ln -snvf "$CODE_DOTFILES_DIR/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

    cat extensions | while read line
    do
        code --install-extension $line
    done  
}

echo "install vscode"

if type "code" > /dev/null 2>&1; then
  echo "vscode already installed."
else
  install_vscode
fi

echo "configure vscode"
configure_vscode