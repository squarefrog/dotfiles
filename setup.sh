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

rm ~/.bash_profile
ln -s $PWD/.bash_profile ~/.bash_profile

rm ~/.profile
ln -s $pwd/.profile ~/.profile

rm ~/.oh-my-zsh/themes/squarefrog.zsh-theme
ln -s $PWD/squarefrog.zsh-theme ~/.oh-my-zsh/themes/squarefrog.zsh-theme

rm ~/.tmux.conf
ln -s $pwd/.tmux.conf ~/.tmux.conf

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
