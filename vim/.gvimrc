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
set guifont=Meslo\ LG\ S\ for\ Powerline

" Have the mouse enabled all the time
set mouse=a

" Set visual bell
set vb

" Local config
if filereadable($HOME . "/.gvimrc.local")
  source ~/.gvimrc.local
endif
