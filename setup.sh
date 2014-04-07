#!/bin/sh

PWD=`pwd`

ln -sf $PWD/.vim ~/.vim
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gvimrc ~/.gvimrc
ln -sf $PWD/.xvimrc ~/.xvimrc
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.bash_profile ~/.bash_profile
ln -sf $PWD/.profile ~/.profile
ln -sf $PWD/squarefrog.zsh-theme ~/.oh-my-zsh/themes/squarefrog.zsh-theme
ln -sf $PWD/.tmux.conf ~/.tmux.conf

mkdir -p $PWD/.vim/bundle

if [ -d "$PWD/.vim/bundle/neobundle.vim" ]; then
  cd $PWD/.vim/bundle/neobundle.vim
  git pull origin master
  cd $PWD
  vim +NeoBundleInstall! +qall
else
  git clone https://github.com/Shougo/neobundle.vim.git $PWD/.vim/bundle/neobundle.vim
  vim +NeoBundleInstall! +qall
fi
