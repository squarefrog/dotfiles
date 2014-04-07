#!/bin/sh

PWD=`pwd`

# Link ALL the files
ln -sf $PWD/.vim ~/.vim
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gvimrc ~/.gvimrc
ln -sf $PWD/.xvimrc ~/.xvimrc
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.bash_profile ~/.bash_profile
ln -sf $PWD/.profile ~/.profile
ln -sf $PWD/squarefrog.zsh-theme ~/.oh-my-zsh/themes/squarefrog.zsh-theme
ln -sf $PWD/.tmux.conf ~/.tmux.conf

# Link iTerm2 preferences if on a Mac
if [ "$(uname)" == "Darwin" ]; then
  ln -sf $PWD/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
fi

mkdir -p $PWD/.vim/bundle

# Install NeoBundle and update packages
if [ -d "$PWD/.vim/bundle/neobundle.vim" ]; then
  cd $PWD/.vim/bundle/neobundle.vim
  git pull origin master
  cd $PWD
  vim +NeoBundleInstall! +qall
else
  git clone https://github.com/Shougo/neobundle.vim.git $PWD/.vim/bundle/neobundle.vim
  vim +NeoBundleInstall! +qall
fi
