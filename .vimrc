" Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#incubate()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on

" Set font to patched powerline font
set guifont=Inconsolata\ for\ Powerline:h16

" Lets give relative line numbers a go
set relativenumber

" Searching
set hlsearch             " highlight the search matches
set incsearch            " show the first match as search strings are typed
set ignorecase smartcase " searching is case insensitive when all lowercase

" Set color scheme
syntax on " Set syntax highlighting on
set background="dark"
let g:solarized_termcolors = 256
let g:solarized_termtrans  = 0
colorscheme solarized

" Have the mouse enabled all the time
set mouse=a

" Default spacing stuff
set nowrap

" 1 tab == 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Use spaces instead of tabs
set expandtab

" Set visual bell
set vb

" Highlight trailing whitespace
set list listchars=tab:\ \ ,trail:·

" Clean up trailing whitespace
map <Leader>c :%s/\s\+$<cr>

" Change history from 20 -> 100
set history=100

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
" I *really* like this.. gives you some context while editing
set scrolloff=8

" Set the textwidth to be 80 chars
set textwidth=80

" Automatically read a file that has changed on disk
set autoread

"------------  KEYBOARD MAPPINGS  ------------

" Make backspace work like most other apps
set backspace=2

" Remap jj to escape key
:imap jj <Esc>

" Remap nerd tree toggle
nmap gt :NERDTreeToggle<CR>

" Change leader from \ to ,
let mapleader=","

" Disable the pesky :Q command
nnoremap Q <nop>

map <Leader>I gg=G``<cr>

" Lots of things to ignore (for Command-T and NerdTree)
set wildignore=system,doc,vendor,log,tmp,*.o,*.fasl,CVS,.git,doc,coverage,build,generated,.hg,.svn,.bundle,*.jpg,*.png,*.gif,*.sqlite3,*.log,*.swp,*.bak,*.dll,*.exe,.sass-cache,*.class

" Resize buffers easier
noremap <silent> <C-F9>  :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>

" Quick edit the vimrc file
nmap <silent> <Leader>ev :e $MYVIMRC<CR>
nmap <silent> <Leader>sv :so $MYVIMRC<CR>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" map spacebar to clear search highlight
nnoremap <Leader><space> :noh<cr>

"""""""""""""""""""""""""""""""""""""
" AIRLINE
"""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set laststatus=2 " Force airline to show all the time
let g:airline_theme             = 'solarized'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
let g:airline_powerline_fonts   = 1
set nocompatible " Disable vi-compatibility
set t_Co=256 " Set colours for vim-airline
set ttimeoutlen=50

"""""""""""""""""""""""""""""""""""""
" RAILS
"""""""""""""""""""""""""""""""""""""
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1


"""""""""""""""""""""""""""""""""""""
" FUNCTIONS
"""""""""""""""""""""""""""""""""""""
" Automatical reload vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
