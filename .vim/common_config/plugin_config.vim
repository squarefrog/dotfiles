" Plugins are managed by Vundle. Once VIM is open run :NeoBundleInstall to
" install plugins.

filetype off

" Plugins requiring no additional configuration or keymaps
NeoBundle "ddollar/nerdcommenter"
NeoBundle "ervandew/supertab"
NeoBundle "altercation/vim-colors-solarized"
NeoBundle "Lokaltog/vim-easymotion"
NeoBundle "tpope/vim-markdown"
NeoBundle "tpope/vim-rails"
NeoBundle "vim-ruby/vim-ruby"
NeoBundle "tpope/vim-surround"


NeoBundle "scrooloose/nerdtree"
  " let NERDTreeHijackNetrw = 0
  let NERDTreeShowHidden=1
  nmap gt :NERDTreeToggle<CR>

NeoBundle "bling/vim-airline"
  let g:airline_powerline_fonts = 1

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif


NeoBundle "tpope/vim-fugitive"
  map <leader>gb :Gblame<CR>
  map <leader>gs :Gstatus<CR>
  map <leader>gd :Gdiff<CR>
  map <leader>gl :Glog<CR>
  map <leader>gc :Gcommit<CR>
  map <leader>gp :Git push<CR>
  map <leader>gw :Gwrite<CR>
