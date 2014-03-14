" Automatically reload vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Format JSON
function! FormatJSON()
  :%!python -m json.tool
endfunction
