#!/usr/bin/env bash
# This is a script for bootstrapping OS X setup

if ! which xcodebuild &> /dev/null; then
  echo "Xcode Command Line Tools must be installed before running this script"
  exit
fi

echo "                                                                             ";
echo "                                                                             ";
echo " ██████╗  ██████╗  ██████╗ ████████╗███████╗████████╗██████╗  █████╗ ██████╗ ";
echo " ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗";
echo " ██████╔╝██║   ██║██║   ██║   ██║   ███████╗   ██║   ██████╔╝███████║██████╔╝";
echo " ██╔══██╗██║   ██║██║   ██║   ██║   ╚════██║   ██║   ██╔══██╗██╔══██║██╔═══╝ ";
echo " ██████╔╝╚██████╔╝╚██████╔╝   ██║   ███████║   ██║   ██║  ██║██║  ██║██║     ";
echo " ╚═════╝  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ";
echo "                                                                             ";
echo "                                                                             ";

if ! which brew &> /dev/null; then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh my zsh..."
  git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  chsh -s /bin/zsh
fi

# Symlink all the things
cd ..
./manage.sh install

# Install vim packages
if [ -d "$HOME/.vim/bundle/neobundle.vim" ]; then
  echo "Updating vim bundles..."
  cd ~/.vim/bundle/neobundle.vim
  git pull origin master
  cd ~
  vim +NeoBundleInstall! +qall
else
  echo "Installing vim bundles..."
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/bundle
  fi
  git clone https://github.com/Shougo/neobundle.vim.git ~/.vim/bundle/neobundle.vim
  vim +NeoBundleInstall! +qall
fi

# Re source .bashrc
source "$HOME/.bashrc"

# Install brew bundles
echo "Installing Brews..."
brew bundle $DOTFILES/osx/Brewfile
brew bundle $DOTFILES/osx/Caskfile

echo "                                                                        "
echo "                                                                        "
echo "........................................................................"
echo "............................ Bootstrap done ............................"
echo "........................................................................"
echo "                                                                        "
echo "                                                                        "
