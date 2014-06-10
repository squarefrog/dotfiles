runtime! before_config/*.vim
  set t_Co=256 " Set colours for vim-airline

" bring in the bundles for mac and windows
set rtp+=~/.vim/bundle/neobundle.vim/
call neobundle#rc()

if !has('win32')
  set shell=/bin/sh
endif

" Load in bundles file
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

runtime! common_config/*.vim
runtime! custom_config/*.vim

set clipboard=unnamed
