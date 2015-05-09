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

removesymlink .aliases
removesymlink .bashrc
removesymlink .profile
removesymlink .shellrc
removesymlink .zshrc

echo "done"

popd > /dev/null 2>&1
