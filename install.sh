#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################


# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

bot "Hello! Let's rock!"

echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
	running "changing your login shell to zsh"
	chsh -s $(which zsh);ok
else
	bot "Looks like you are already using zsh. woot!"
fi

[ -z "$DOTFILES" ] && DOTFILES=$PWD
if env | grep -q ^DOTFILES=
then
  echo env variable is already exported
  bot "DOTFILES already exported!"
else
  bot "DOTFILES temporarily exported!"
  export DOTFILES
fi

bot "Pulling in prezto"
# check if prezto exists?
if [[ -d $DOTFILES/prezto ]]; then
  running "Prezto already cloned, updating..."
  git submodule update --recursive
else
  running "Cloning Prezto repo..."
  git submodule update init --recursive
fi
ok

pushd ~ > /dev/null 2>&1

bot "Creating symlinks for prezto dotfiles"
linkpreztofolder
linkpreztofile zlogin
linkpreztofile zlogout
linkpreztofile zpreztorc
linkpreztofile zprofile
linkpreztofile zshenv
linkpreztofile zshrc

bot "Creating symlinks for project dotfiles..."
symlinkifne .gemrc
symlinkifne .gitconfig
symlinkifne .gitignore_global
symlinkifne .gvimrc
symlinkifne .tmux.conf
symlinkifne .vimrc
symlinkifne .vimrc.bundles
symlinkifne .xvimrc

THEME_NAME="tomorrow-night-xcode.dvtcolortheme"
XCODETHEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
if [[ ! -e "$XCODETHEMES_DIR/$THEME_NAME" ]]; then
  bot "Installing Tomorrow Night Xcode theme..."
  if [[ ! -d "$XCODETHEMES_DIR" ]]; then
    mkdir -p $XCODETHEMES_DIR
  fi
  ln -s "$DOTFILES/themes/$THEME_NAME" "$XCODETHEMES_DIR/$THEME_NAME"
else
  bot "Xcode theme already installed"
fi

if [[ -d "$HOME/.vim/bundle/neobundle.vim" ]]; then
  bot "Updating vim packages..."
  cd $HOME/.vim/bundle/neobundle.vim
  git pull origin master > /dev/null 2>&1
  cd $DOTFILES
  vim -c "NeoBundleInstall!" -c "qa!"
else
  bot "Installing neobundle.vim..."
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/bundle
  fi
  git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim > /dev/null 2>&1
  vim -c "NeoBundleInstall!" -c "qa!"
fi

PLUGIN_PATH="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin"
if [[ ! -d $PLUGIN_PATH ]]; then
  bot "Installing Alcatraz..."
  curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh > /dev/null 2>&1
else
  bot "Alcatraz already installed"
fi

popd > /dev/null 2>&1

./osx.sh

bot "Woot! All done."
