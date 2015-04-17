" bring in the bundles for mac and windows
set rtp+=~/.vim/bundle/neobundle.vim/

if !has('win32')
  set shell=/bin/sh
endif

" Load in bundles file
call neobundle#begin()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call neobundle#end()
filetype plugin indent on
syntax on
silent! colorscheme Tomorrow-Night   " Set color scheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
set clipboard=unnamed

" Highlight trailing whitespace - disabled for now as list breaks linebreak
"set list listchars=tab:\ \ ,trail:·

" CocoaPods
au BufNewFile,BufRead Podfile,*.podspec      set filetype=ruby

" XML
let g:xml_syntax_folding=1
"au FileType xml setlocal foldmethod=syntax

" Enable spell check for Markdown
autocmd BufNewFile,BufRead *.markdown setlocal spell


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make backspace work like most other apps
set backspace=2

" Remap jj to escape key
imap jj <Esc>

" Change leader from \ to ,
let mapleader=","

" Disable the pesky :Q command
nnoremap Q <nop>

" Work around my mistakes
cmap WQ wq
cmap Wq wq
cmap W w
cmap Q q

" Reindent all
map <Leader>I gg=G``<cr>

" Clean up trailing whitespace
map <Leader>c :%s/\s\+$<cr>

" Make indenting easier
vnoremap < <gv
vnoremap > >gv

" Mac OS X clipboard integration
vmap <F1> :w !pbcopy<CR><CR>
nmap <F2> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

" Toggle search highlighting
nnoremap <F3> :set hlsearch!<CR>
nnoremap <Leader><space> :noh<cr>

" Show highlight group below cursor
nnoremap <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Call format json
map <Leader>fj :call FormatJSON()<CR>

" Set spell check  region to British English
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_gb

" Remap make Y act like other capitals
nnoremap Y y$

" Quick edit vimrc in a new vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Quick edit vimrc.bundles in a new vertical split
nnoremap <leader>eb :vsplit ~/.vimrc.bundles<cr>

" I don't want help!
nmap <F1> :echo<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Automatically reload vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Format JSON
function! FormatJSON()
  :%!python -m json.tool
endfunction

" Add a function call so when i forget what the mapping is I'm not stuck..
command! PrettyJSON call FormatJSON()

" Insert current date stamp in jekyll format
nnoremap <F5> "=strftime("%Y-%m-%d %H:%M:%S %z")<CR>p

" Format xml
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" Call format xml
map <Leader>fx :call DoPrettyXML()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local override
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
