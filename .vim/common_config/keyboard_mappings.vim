" Make backspace work like most other apps
set backspace=2

" Remap jj to escape key
imap jj <Esc>

" Change leader from \ to ,
let mapleader=","

" Disable the pesky :Q command
nnoremap Q <nop>

map <Leader>I gg=G``<cr>

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

" Clean up trailing whitespace
map <Leader>c :%s/\s\+$<cr>

" Map indentation to match Xcode
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv
nmap <T-[> <<
nmap <T-]> >>
vmap <T-[> <gv
vmap <T-]> >gv

" Toggle search highlighting
nnoremap <F3> :set hlsearch!<CR>
