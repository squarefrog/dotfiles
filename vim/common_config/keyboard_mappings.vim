" Make backspace work like most other apps
set backspace=2

" Remap jj to escape key
imap jj <Esc>

" Change leader from \ to ,
let mapleader=","

" Disable the pesky :Q command
nnoremap Q <nop>

" Work around my mistakes
:command WQ wq
:command Wq wq
:command W w
:command Q q

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

" Call format json
map <Leader>fj :call FormatJSON()<CR>

" Set spell check  region to British English
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_gb

" Remap make Y act like other capitals
nnoremap Y y$
