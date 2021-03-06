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
set guifont=Meslo\ LG\ S\ for\ Powerline:h13

" Have the mouse enabled all the time
set mouse=a

" Set visual bell
set vb

" Disable cmd+p shortcut
if has("gui_macvim")
  macmenu File.Print key=<nop>
  map <D-p> :CtrlP<CR>
endif

" Local config
if filereadable($HOME . "/.gvimrc.local")
  source ~/.gvimrc.local
endif
