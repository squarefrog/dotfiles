" resize current buffer by +/- 5
nnoremap <D-left> :vertical resize -5<cr>
nnoremap <D-down> :resize +5<cr>
nnoremap <D-up> :resize -5<cr>
nnoremap <D-right> :vertical resize +5<cr>

" hide scroll bars and tab bars in mac vim
set go-=r
set go-=L
set go-=T

set guioptions-=T         " Remove toolbar
set guioptions-=r         " Remove right scrollbar
