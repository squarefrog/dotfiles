# Source the major default settings shared
# between zsh and bash

if [[ ! -f $HOME/.shellrc ]];then
  echo "$HOME/.shellrc doesn't exist. Run ./manage.sh install again"
else
  source $HOME/.shellrc
fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="squarefrog"

# Disable auto correct
DISABLE_CORRECTION="true"

# ZSH plugins
plugins=(git terminalapp pod)

# Source files and paths
source $ZSH/oh-my-zsh.sh
source ~/.rvm/scripts/rvm
