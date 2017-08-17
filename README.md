# Dotfiles

## Clone the reponsitory

    $ git clone --recursive https://github.com/squarefrog/dotfiles.git ~/dotfiles

## Install dependencies
### macOS

    $ ./mac/brew

Optionally, use the `cask` script to download common applications, and the `macOS` script to set sane preferences.

    $ ./mac/cask
    $ ./mac/macOS

### Ubuntu

    $ sudo ./ubuntu/ubuntu

## Set your Git user:

    $ cp ~/dotfiles/git/.gitconfig.local.example ~/.gitconfig.local
    $ vim ~/.gitconfig.local

## Install

Run the install script which uses `stow` to create symbolic links to the root of your home folder

    $ ./install

## Set shell to zsh

    $ chsh -s $(which zsh)

## Finally...

Restart your device.
