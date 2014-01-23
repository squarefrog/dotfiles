" Plugin stuff
set nocompatible

" Set color scheme
syntax on " Set syntax highlighting on
colorscheme Tomorrow-Night

" Set line numbers
set number

" Setup the path for neobundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

" UTF-8 is the bestest
set encoding=utf-8

" Set leader to ,
let mapleader=","

" Syntax highlighting
syntax on

" Lots of things to ignore (for Command-T and NerdTree)
set wildignore=system,doc,vendor,log,tmp,*.o,*.fasl,CVS,.git,doc,coverage,build,generated,.hg,.svn,.bundle,*.jpg,*.png,*.gif,*.sqlite3,*.log,*.swp,*.bak,*.dll,*.exe,.sass-cache,*.class

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
" I *really* like this.. gives you some context while editing
set scrolloff=8

" Set the textwidth to be 80 chars
set textwidth=80

" Set soft wrapping
set wrap linebreak nolist

" Automatically read a file that has changed on disk
set autoread

" Default spacing stuff
" 1 tab == 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Use spaces instead of tabs
set expandtab

