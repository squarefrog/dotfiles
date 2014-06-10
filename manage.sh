#!/bin/bash

FOLDERS=$(ls -d */);
EXCLUDED=(themes osx plugins Preferences)

function link_file () {
  local filename=$1
  local basename=$(basename "$1")
  local path="$HOME/.$basename"

  if [ ! -e $path ]; then
    echo "Linking $filename to $path"
    ln -s $PWD/$filename $path
  fi
}

function unlink_file () {
  local filename=$(basename "$1")
  local path="$HOME/.$filename"

  if [ -e $path ]; then
    echo "Removing $path"
    rm $path
  fi
}

function link_files () {
  local folder=$1

  for file in "$folder"*; do
    link_file $file
  done
}

function unlink_files () {
  local folder=$1

  for file in "$folder"*; do
    unlink_file $file
  done
}

# Fuction to print the usage and exit when there's bad input
function die () {
  echo "Usage ./manage.sh {install|remove}"
  exit
}

if [ ! -e $HOME/.vim ]; then
  ln -s $PWD/vim $HOME/.vim
fi

for folder in $FOLDERS; do

  if [[ ! ${EXCLUDED[*]} =~ ${folder%/} ]]; then

    if [[ $1 == "install" ]]; then
      link_files $folder

    elif [[ $1 == "remove" ]]; then
      unlink_files $folder

    else
      die
    fi
  fi
done
