#!/usr/bin/env bash

###########################
# Migrate from using oh-my-zsh to prezto
###########################

pushd ~ > /dev/null 2>&1

function removesymlink {
  if [[ -L ~/$1 ]]; then
    echo "Unlinking $1"
    rm $1;
  fi
}

removesymlink .zlogin
removesymlink .zlogout
removesymlink .zpreztorc
removesymlink .zprofile
removesymlink .zshenv
removesymlink .zshrc

removesymlink .aliases
removesymlink .bashrc
removesymlink .gemrc
removesymlink .gitconfig
removesymlink .gitignore_global
removesymlink .gvimrc
removesymlink .profile
removesymlink .shellrc
removesymlink .tmux.conf
removesymlink .vimrc
removesymlink .vimrc.bundles
removesymlink .xvimrc
removesymlink .zshrc
removesymlink .zprezto

echo "done"

popd > /dev/null 2>&1
