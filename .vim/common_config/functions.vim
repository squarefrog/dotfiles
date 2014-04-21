" Automatically reload vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Format JSON
function! FormatJSON()
  :%!python -m json.tool
endfunction

" Insert current date stamp in jekyll format
:nnoremap <F5> "=strftime("%Y-%m-%d %H:%M:%S +0000")<CR>p
