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
plugins=(brew brew-cask gem git pod terminalapp)

# Source files and paths
source $ZSH/oh-my-zsh.sh

if [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi

# Load the zsh-syntax-highlighting plugin
if [ -f $DOTFILES/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source $DOTFILES/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Enable higlighting
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

  # Override highlighting
  ZSH_HIGHLIGHT_STYLES[default]=none
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green
  ZSH_HIGHLIGHT_STYLES[alias]=none
  ZSH_HIGHLIGHT_STYLES[builtin]=none
  ZSH_HIGHLIGHT_STYLES[function]=none
  ZSH_HIGHLIGHT_STYLES[command]=none
  ZSH_HIGHLIGHT_STYLES[precommand]=none
  ZSH_HIGHLIGHT_STYLES[commandseparator]=none
  ZSH_HIGHLIGHT_STYLES[hashed-command]=none
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none
  ZSH_HIGHLIGHT_STYLES[path_approx]=none
  ZSH_HIGHLIGHT_STYLES[globbing]=none
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=blue
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=blue
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[assign]=none
fi

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
