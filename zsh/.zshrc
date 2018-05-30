# Source all config files
for config (~/.zsh/*.zsh); do
  source $config
done

source ".zsh/functions/xcode.zsh"

# Reload keybindings as the vi prompt override seems to reset history search
# https://github.com/zsh-users/zsh-history-substring-search/issues/70
source "$HOME/.zsh/keybindings.zsh"
