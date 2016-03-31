#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# Derived from
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

running "exporting dotfiles"
[ -z "$DOTFILES" ] && DOTFILES=$PWD
if env | grep -q ^DOTFILES=
then
  puts "already exported"
else
  export DOTFILES
  puts "exported"
fi
ok

pushd ~ > /dev/null 2>&1

bot "Creating symlinks for project dotfiles"
symlinkifne .gemrc
symlinkifne .gitconfig
symlinkifne .gitignore_global
symlinkifne .gvimrc
symlinkifne .tmux.conf
symlinkifne .vimrc
symlinkifne .vimrc.bundles
symlinkifne .xvimrc

popd > /dev/null 2>&1

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

# Run OS X install script
if [[ "$OSTYPE" == "darwin"* ]]; then
  ./osx.sh
fi

bot "Woot! All done."

