runtime! before_config/*.vim

" resize current buffer by +/- 5
" D = command key
nnoremap <D-left> :vertical resize -5<cr>
nnoremap <D-down> :resize +5<cr>
nnoremap <D-up> :resize -5<cr>
nnoremap <D-right> :vertical resize +5<cr>

" hide scroll bars and tab bars in mac vim
set guioptions-=T         " Remove toolbar
set guioptions-=r         " Remove right scrollbar
set guioptions-=L         " Remove left scrollbar

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

" Set visual bell
set vb

" Highlight trailing whitespace
set list listchars=tab:\ \ ,trail:·

runtime! custom_config/*.gvim
