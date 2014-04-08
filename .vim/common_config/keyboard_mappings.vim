" Make backspace work like most other apps
set backspace=2

" Remap jj to escape key
imap jj <Esc>

" Change leader from \ to ,
let mapleader=","

" Disable the pesky :Q command
nnoremap Q <nop>

" Reindent all
map <Leader>I gg=G``<cr>

" Clean up trailing whitespace
map <Leader>c :%s/\s\+$<cr>

" Make indenting easier
nnoremap > >>
nnoremap < <<

" Toggle search highlighting
nnoremap <F3> :set hlsearch!<CR>
nnoremap <Leader><space> :noh<cr>

" Call format json
map <Leader>fj :call FormatJSON()<CR>

" Set spell check  region to British English
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_gb
