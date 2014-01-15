#!/bin/sh

PWD=`pwd`

rm ~/.vim
ln -s $PWD/.vim ~/.vim

rm ~/.vimrc
ln -s $PWD/.vimrc ~/.vimrc

rm ~/.gvimrc
ln -s $PWD/.gvimrc ~/.gvimrc

rm ~/.xvimrc
ln -s $PWD/.xvimrc ~/.xvimrc

rm ~/.zshrc
ln -s $PWD/.zshrc ~/.zshrc

rm ~/.oh-my-zsh/squarefrog.zsh-theme
ln -s $PWD/squarefrog.zsh-theme ~/.oh-my-zsh/squarefrog.zsh-theme

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
