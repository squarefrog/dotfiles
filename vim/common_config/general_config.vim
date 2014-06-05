set nocompatible

" Setup the path for neobundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Lots of things to ignore (for Command-T and NerdTree)
set wildignore=system,doc,vendor,log,tmp,*.o,*.fasl,CVS,.git,doc,coverage,build,generated,.hg,.svn,.bundle,*.jpg,*.png,*.gif,*.sqlite3,*.log,*.swp,*.bak,*.dll,*.exe,.sass-cache,*.class,.DS_Store

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
" I *really* like this.. gives you some context while editing
set scrolloff=8

let mapleader=","        " Set leader to ,
set encoding=utf-8       " UTF-8 is the bestest
set number               " Set line numbers
set laststatus=2         " Always show the statusline
set t_Co=256             " Explicitly tell Vim that the terminal supports 256 colors
set lazyredraw           " Don't redraw vim in all situations
set synmaxcol=300        " The max number of columns to try and highlight
set noerrorbells         " Don't make noise
set visualbell           " Don't show bells
set autoread             " Watch for file changes and auto update
set showmatch            " Set show matching parenthesis
set matchtime=2          " The amount of time matches flash
set display=lastline     " Display super long wrapped lines
set ignorecase           " Ignore case when searching
set smartcase            " Ignore case if search is lowercase, otherwise case-sensitive
set gdefault             " Adds g at the end of substitutions by default
set expandtab            " Default spacing stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
set foldlevel=20         " Start with folds unfolded
set directory=/tmp/      " Set temporary directory (don't litter local dir with swp/tmp files)
set wrap                 " Wrap text
set linebreak            " Word wrap
set nolist               " List disables linebreak
set hlsearch             " highlight the search matches
set incsearch            " show the first match as search strings are typed
set ignorecase smartcase " searching is case insensitive when all lowercase
set mouse=a              " Allow mouse scrolling even when in tmux

" Highlight trailing whitespace - disabled for now as list breaks linebreak
"set list listchars=tab:\ \ ,trail:·

" CocoaPods
au BufNewFile,BufRead Podfile,*.podspec      set filetype=ruby
