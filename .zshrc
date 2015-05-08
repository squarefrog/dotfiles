# Source the major default settings shared
# between zsh and bash
if [[ ! -f $HOME/.shellrc ]];then
  echo "$HOME/.shellrc doesn't exist. Run ./manage.sh install again"
else
  source $HOME/.shellrc
fi

# Path to your oh-my-zsh configuration.
ZSH=$DOTFILES/oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="squarefrog"

# Disable auto correct
DISABLE_CORRECTION="true"

# ZSH plugins
plugins=(brew brew-cask gem git git-flow pod terminalapp xcode z)

# Source files and paths
source $ZSH/oh-my-zsh.sh

if [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
