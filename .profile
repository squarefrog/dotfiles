# Prefer GB English
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Make vim the default editor
export EDITOR="vim"

# General Paths
export PATH=$PATH:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/bin

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin 

# Custom RubyGem global location
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Load RVM into a shell
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

# Export Brew path
export PATH=/usr/local/bin:$PATH

# OS X context colouring
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
