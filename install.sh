#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################


# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

bot "Lets get ready to rumble!"
bot "Preparing..."

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    running "creating ~/.dotfiles_backup folder"
    mkdir ~/.dotfiles_backup
    ok
fi

echo $0 | grep zsh > /dev/null 2>&1 | true
running "zsh"
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  puts "setting login shell"
	chsh -s $(which zsh);
else
  puts "already set"
fi
ok

running "dotfiles"
[ -z "$DOTFILES" ] && DOTFILES=$PWD
if env | grep -q ^DOTFILES=
then
  puts "already exported"
else
  export DOTFILES
  puts "exported"
fi
ok

running "prezto"
# check if prezto exists?
if [[ -d $DOTFILES/prezto ]]; then
  puts "updating"
  git submodule update --recursive
else
  puts "cloning"
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

bot "Creating symlinks for project dotfiles"
symlinkifne .gemrc
symlinkifne .gitconfig
symlinkifne .gitignore_global
symlinkifne .gvimrc
symlinkifne .tmux.conf
symlinkifne .vimrc
symlinkifne .vimrc.bundles
symlinkifne .xvimrc

if [[ -d "$HOME/.vim/bundle/neobundle.vim" ]]; then
  bot "Updating vim packages"
  pushd $HOME/.vim/bundle/neobundle.vim > /dev/null 2>&1
  git pull origin master > /dev/null 2>&1
  popd > /dev/null 2>&1
else
  bot "Installing neobundle.vim"
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/bundle
  fi
  git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim > /dev/null 2>&1
fi
vim -c "NeoBundleInstall!" -c "qa!"

bot "Setting up Xcode"
running "Tomorrow Night"
THEME_NAME="tomorrow-night-xcode.dvtcolortheme"
XCODETHEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
if [[ ! -e "$XCODETHEMES_DIR/$THEME_NAME" ]]; then
  puts "installing theme"
  if [[ ! -d "$XCODETHEMES_DIR" ]]; then
    mkdir -p $XCODETHEMES_DIR
  fi
  ln -s "$DOTFILES/themes/$THEME_NAME" "$XCODETHEMES_DIR/$THEME_NAME"
  ok
else
  puts "exists, skipping";ok
fi

running "Alcatraz"
PLUGIN_PATH="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin"
if [[ ! -d $PLUGIN_PATH ]]; then
  puts "installing"
  curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh > /dev/null 2>&1
  ok
else
  puts "exists, skipping";ok
fi

popd > /dev/null 2>&1

./osx.sh

bot "Woot! All done."
