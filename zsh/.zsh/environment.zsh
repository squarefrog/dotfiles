# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Language
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# Paths
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# OS X context colouring
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Path to dotfiles repo
export DOTFILES="$(dirname $(readlink $HOME/.vimrc))"
